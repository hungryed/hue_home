module HueHome
  class Client
    attr_reader :username

    def initialize(username = nil)
      @username = username || get_username
      raise ArgumentError.new("You must provide a username in the configuration or in new") unless @username
    end

    def lights
      bridge_collection.lights
    end

    def bridges
      bridge_collection.bridges
    end

    def bridge_collection
      @bridge_collection ||= HueHome::Bridge::Collection.new(username)
    end

    def get_username
      HueHome.configuration.username
    end
  end
end
