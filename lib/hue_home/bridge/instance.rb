require "json"

module HueHome
  module Bridge
    class Instance
      attr_reader :response, :client_username

      def initialize(response:,client_username:)
        @response = response
        @client_username = client_username
      end

      def ip
        response.fetch("internalipaddress")
      end

      def current_user_id
        user_collection.current_user_id
      end

      def id
        response.fetch("id")
      end

      def delete_user(username)
        user_collection.delete_user(username)
      end

      def lights
        lights_collection.lights
      end

      def groups
        groups_collection.groups
      end

      def lights_by_ids(light_ids)
        lights.select { |light|
          light_ids.include?(light.id)
        }
      end

      private

      def groups_collection
        @groups_collection ||= Group::Collection.new(
          bridge: self
        )
      end

      def lights_collection
        @lights_collection ||= Light::Collection.new(
          bridge: self
        )
      end

      def user_collection
        @user_collection ||= User::BridgeCollection.new(
          client_username: client_username,
          bridge: self
        )
      end

      def bridge
        self
      end
    end
  end
end
