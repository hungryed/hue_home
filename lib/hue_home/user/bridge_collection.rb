module HueHome
  module User
    class BridgeCollection
      attr_reader :bridge, :client_username
      include HueHome::Connection
      url(:create_user, :post) { "/api" }
      url(:delete_user, :delete) { |current_user_id, user_id| "/api/#{current_user_id}/config/whitelist/#{user_id}" }

      def initialize(client_username:, bridge:)
        @bridge = bridge
        @client_username = client_username
      end

      def current_user_id
        @current_user_id ||= find_or_create(client_username)
      end

      def find_or_create(username)
        find_user(username) || create_user(username)
      end

      def delete_user(username)
        user_id = find_user(username) || username
        response = request(:delete_user, current_user_id, user_id) {}
        parsed_response = parse_and_validate_response(response)
        parsed_response[0]["success"]
      end

      private

      def id
        bridge.id
      end

      def find_user(username)
        user = parsed_users[username]
        user && user["internal_id"]
      end

      def create_user(username)
        response = request(:create_user) do |conn|
          conn.body = {
            devicetype: "#{username}#hue_home_ruby"
          }.to_json
        end
        parsed_response = parse_and_validate_response(response)
        user_id = parsed_response[0]["success"]["username"]
        write_to_file!({
          username => {
            internal_id: user_id
          }
        })
        user_id
      end

      def write_to_file!(new_data)
        data = parsed_users.merge(new_data)
        Utilities::FileUtilities.mkdir_p(id)
        File.open(users_file, "w+") { |f|
          f.write data.to_json
        }
      end

      def parsed_users
        return {} unless File.file?(users_file)
        JSON.parse(File.read(users_file))
      end

      def users_file
        Utilities::FileUtilities.path_for(id, "users.json")
      end
    end
  end
end
