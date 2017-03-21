require_relative "connection_builder"

module HueHome
  module Connection
    def self.included(klass)
      klass.include(InstanceMethods)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      class UrlDefinitionError < Error; end
      class NoUrl < Error; end

      def url_for(name, *args)
        url_block = url_definition_for(name)[:block]
        url_block.call(*args)
      end

      def request_method(name)
        url_definition_for(name)[:method_name]
      end

      def url_definition_for(name)
        urls.fetch(name.to_sym) {
          raise NoUrl.new("No url defined for #{name}")
        }
      end

      def url(name,method_name,&block)
        raise UrlDefinitionError, "Url name can not be nil" if name.nil?
        if existing_key?(name)
          raise UrlDefinitionError,"Duplicate definitions for Url - #{name} on - #{to_s}"
        end
        self_urls[name.to_sym] = {
          method_name: method_name,
          block: block
        }
      end

      def urls
        parent_urls.merge(self_urls)
      end

      def self_urls
        @self_urls ||= {}
      end

      def parent_urls
        @parent_urls ||= {}
      end

      def existing_key?(key_name)
        !self_urls[key_name.to_sym].nil?
      end

      def inherited(klass)
        klass.parent_urls.merge!(urls)
      end
    end

    module InstanceMethods
      include ConnectionBuilder
      class UnsuccessfulResponse < Error; end
      class InvalidBridgeState < Error; end

      def bridge
        raise InvalidBridgeState.new("Must respond to #bridge")
      end

      def check_bridge
        raise InvalidBridgeState.new("Must be a HueHome::Bridge") unless bridge.is_a?(HueHome::Bridge::Instance)
      end

      def parse_and_validate_response(response)
        parsed_response = JSON.parse(response.body)
        array_response = parsed_response
        if parsed_response.is_a?(Array)
          potential_first_object = parsed_response[0]
          error = potential_first_object["error"]
          HueHome.raise_error(error) if error
          raise UnsuccessfulResponse.new("Bad response: #{response.body}") unless response.success?
        end
        parsed_response
      end

      def request(name, *args, &blk)
        connection = bridge_connection
        request_method = self.class.request_method(name)
        url = self.class.url_for(name, *args)
        connection.send(request_method, url) do |conn|
          blk.call(conn)
        end
      end

      def bridge_connection
        check_bridge
        build_connection(base_url: "http://#{bridge.ip}")
      end
    end
  end
end
