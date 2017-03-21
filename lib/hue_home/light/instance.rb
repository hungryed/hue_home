require_relative "state/handler"

module HueHome
  module Light
    class Instance
      attr_reader :bridge, :id, :initial_state

      def initialize(bridge:, id:, initial_state:)
        @bridge = bridge
        @id = id
        @initial_state = initial_state
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

      def state_handler
        @state_handler ||= State::Handler.new(
          light: self,
          bridge: bridge,
          initial_state: initial_state
        )
      end

      def set_state(options)
        state_handler.set_state(options)
      end

      def current_user_id
        @current_user_id ||= bridge.current_user_id
      end
    end
  end
end
