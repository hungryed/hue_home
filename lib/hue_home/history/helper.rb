module HueHome
  module History
    module Helper
      def add_history_item(options)
        wrap_history_call do
          history.add(make_history_item_from(options))
        end
      end

      def wrap_history_call
        if configuration.store_light_state_history
          yield
        end
      end

      def make_history_item_from(options)
        History::Instance.new(options)
      end

      def configuration
        HueHome.configuration
      end

      def history
        @history ||= History::Collection.new
      end
    end
  end
end
