module HueHome
  class Configuration
    class << self
      def instance
        @instance ||= new
      end

      def configure(&block)
        instance.configure_from_block(&block)
      end
    end

    DEFAULTS = {
      :debug => true,
      :storage_path_relative_to_home => ".hue",
      :store_light_state_history => true,
      :username => "joe",
    }

    attr_accessor *DEFAULTS.keys

    def initialize
      DEFAULTS.each do |key, value|
        self.send("#{key}=", value)
      end
    end

    def configure_from_block(&block)
      instance_eval(&block)
    end
  end
end
