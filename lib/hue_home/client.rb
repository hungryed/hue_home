module HueHome
  class Client
    attr_reader :username, :command_line

    def initialize(username: nil, command_line: false)
      @command_line = command_line
      @username = username || get_username
      raise ArgumentError.new("You must provide a username in the configuration or in new") unless @username
    end

    def lights
      bridge_collection.lights
    end

    def groups
      bridge_collection.groups
    end

    def bridges
      bridge_collection.bridges
    end

    def bridge_collection
      @bridge_collection ||= HueHome::Bridge::Collection.new(username)
    end

    def get_username
      username_fetcher.current_username
    end

    def username_fetcher
      @username_fetcher ||= User::Fetcher.new(
        command_line: command_line
      )
    end
  end
end
