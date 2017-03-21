require_relative "instance"

module HueHome
  module Group
    class Collection
      attr_reader :bridge
      include HueHome::Connection
      url(:get_groups, :get) { |current_user_id| "/api/#{current_user_id}/groups" }

      def initialize(bridge:)
        @bridge = bridge
      end

      def groups
        @groups ||= build_groups
      end

      private

      def build_groups
        fetch_groups_response.map do |id, state|
          Group::Instance.new(
            id: id,
            bridge: bridge,
            initial_state: state
          )
        end
      end

      def fetch_groups_response
        response = request(:get_groups, current_user_id) {}
        parse_and_validate_response(response)
      end

      def current_user_id
        @current_user_id ||= bridge.current_user_id
      end
    end
  end
end
