require "hue_home/version"
require "faraday"
require "hue_home/error"
require "hue_home/core"
require "hue_home/configuration"
require "hue_home/connection"
require "hue_home/history"
require "hue_home/utilities"
require "hue_home/group"
require "hue_home/light"
require "hue_home/bridge"
require "hue_home/client"

module HueHome
  class << self
    def raise_error(error_response)
      klass = HueHome::RESPONSE_ERROR_MAP[error_response['type']] || UnknownError unless klass
      raise klass.new(error_response['description'])
    end

    def configuration
      Configuration.instance
    end

    def configure(&block)
      Configuration.configure(&block)
    end

    def client(command_line: false)
      @client ||= Client.new(command_line: command_line)
    end
  end
end
