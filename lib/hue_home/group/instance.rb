require_relative "state/handler"

module HueHome
  module Group
    class Instance
      attr_reader :bridge, :id, :initial_state, :state
      include HueHome::Connection
      url(:get_group_attributes, :get) { |current_user_id, id| "/api/#{current_user_id}/groups/#{id}" }
      url(:set_group_attributes, :put) { |current_user_id, id| "/api/#{current_user_id}/groups/#{id}" }

      def initialize(bridge:, id:, initial_state:)
        @bridge = bridge
        @id = id
        @initial_state = initial_state
        @state = initial_state
      end

      def on!
        state_handler.on!
      end

      def off!
        state_handler.off!
      end

      def undo!
        state_handler.undo!
      end

      def redo!
        state_handler.redo!
      end

      def go_crazy!
        state_handler.go_crazy!
      end

      def reset!
        @lights = nil
        @state = nil
      end

      def name
        current_state.fetch("name")
      end

      def lights
        @lights ||= bridge.lights_by_ids(light_ids)
      end

      def light_ids
        current_state.fetch("lights")
      end

      def current_state
        @state ||= JSON.parse(get_current_state)
      end

      def add_light(light)
        light_id = light.is_a?(HueHome::Light::Instance) ? light.id : light
        params = {
          lights: light_ids + [light_id]
        }
        send_group_attribute_request(params) do
          reset!
        end
      end

      def remove_light(light)
        light_id = light.is_a?(HueHome::Light::Instance) ? light.id : light
        params = {
          lights: light_ids - [light_id]
        }
        send_group_attribute_request(params) do
          reset!
        end
      end

      def name=(new_name)
        send_group_attribute_request({name: new_name}) do
          @name = new_name
        end
      end

      def send_group_attribute_request(params)
        response = request(:set_group_attributes, current_user_id, id) do |conn|
          conn.body = {
            name: new_name
          }.to_json
        end
        parse_and_validate_response(response)
        yield if block_given?
        response.body
      end

      def get_current_state
        response = request(:get_group_attributes, current_user_id, id) {}
        parse_and_validate_response(response)
        response.body
      end

      def details
        "name: '#{name}'; id: #{id}"
      end

      def state_handler
        @state_handler ||= State::Handler.new(
          group: self,
          bridge: bridge,
          initial_state: initial_state
        )
      end

      def set_state(options)
        state_handler.set_state(**options)
      end

      def current_user_id
        @current_user_id ||= bridge.current_user_id
      end
    end
  end
end
