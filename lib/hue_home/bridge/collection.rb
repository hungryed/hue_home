require_relative "instance"

module HueHome
  module Bridge
    class Collection
      attr_reader :client_username
      include ConnectionBuilder
      HUE_URL = "https://www.meethue.com"
      class UnsuccessfulLookup < Error; end

      def initialize(client_username)
        @client_username = client_username
      end

      def bridges
        @bridges ||= build_bridges
      end

      def lights
        bridges.map(&:lights).flatten
      end

      private

      def build_bridges
        Array(parsed_response).map do |response|
          Instance.new(client_username: client_username, response: response)
        end
      end

      def base_connection
        build_connection(base_url: HUE_URL)
      end

      def response
        @response ||= base_connection.get do |conn|
          conn.url("/api/nupnp")
        end
      end

      def parsed_response
        @parsed_response ||= begin
          unless response.success?
            raise UnsuccessfulLookup.new("Failed to lookup bridge ips. Response: #{response.body}")
          end
          JSON.parse(response.body)
        end
      end
    end
  end
end
