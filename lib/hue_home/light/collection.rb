require_relative "instance"

module HueHome
  module Light
    class Collection
      attr_reader :bridge
      include HueHome::Connection
      url(:get_lights, :get) { |current_user_id| "/api/#{current_user_id}/lights" }

      def initialize(bridge:)
        @bridge = bridge
      end

      def lights
        @lights ||= build_lights
      end

      private

      def build_lights
        fetch_light_response.map do |id, state|
          Light::Instance.new(
            id: id,
            bridge: bridge,
            initial_state: state
          )
        end
      end

      def fetch_light_response
        response = request(:get_lights, current_user_id) {}
        parse_and_validate_response(response)
      end

      def current_user_id
        @current_user_id ||= bridge.current_user_id
      end
    end
  end
end
