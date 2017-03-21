require_relative "state/handler"

module HueHome
  module Light
    class Instance
      attr_reader :bridge, :id, :initial_state, :name
      include HueHome::Connection
      url(:change_name, :put) { |current_user_id, id| "/api/#{current_user_id}/lights/#{id}" }

      def initialize(bridge:, id:, initial_state:)
        @bridge = bridge
        @id = id
        @initial_state = initial_state
        @name = initial_state.fetch("name")
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

      def name=(new_name)
        response = request(:change_name, current_user_id, id) do |conn|
          conn.body = {
            name: new_name
          }.to_json
        end
        parse_and_validate_response(response)
        @name = new_name
        response
      end

      def details
        "name: '#{name}'; id: #{id}"
      end

      def state_handler
        @state_handler ||= State::Handler.new(
          light: self,
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
