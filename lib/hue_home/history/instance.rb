module HueHome
  module History
    class Instance
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def make_active!
        @active = true
      end

      def make_inactive!
        @active = false
      end

      def active?
        !!@active
      end
    end
  end
end
