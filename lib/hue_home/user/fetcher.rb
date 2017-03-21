require "highline"

module HueHome
  module User
    class Fetcher
      attr_reader :command_line

      def initialize(command_line:)
        @command_line = command_line
      end

      def current_username
        HueHome.configuration.username || stored_username
      end

      def stored_username
        return unless command_line
        old_username || user_typed_username
      end

      def old_username
        parsed_usernames["username"]
      end

      def user_typed_username
        @user_typed_username ||= ask_for_username
      end

      def ask_for_username
        answer = highline_cli.ask "Username:"
        write_to_file!({username: answer})
        answer
      end

      def write_to_file!(new_data)
        data = parsed_usernames.merge(new_data)
        File.open(usernames_file, "w+") { |f|
          f.write data.to_json
        }
      end

      def parsed_usernames
        return {} unless File.file?(usernames_file)
        JSON.parse(File.read(usernames_file))
      end

      def usernames_file
        Utilities::FileUtilities.path_for("usernames.json")
      end

      def highline_cli
        @highline_cli ||= HighLine.new
      end
    end
  end
end
