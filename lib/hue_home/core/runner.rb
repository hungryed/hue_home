require "thor"

module HueHome
  module Core
    class Runner < Thor
      desc "hello NAME", "say hello to NAME"
      def hello(name)
        puts "Hello #{name}"
      end

      desc "lights", "list the lights"
      def lights
        client.lights.each do |light|
          puts light.details
        end
      end

      desc "groups", "list the groups"
      def groups
        client.groups.each do |group|
          puts group.details
        end
      end

      desc 'all_lights ON|OFF', 'Set the state of all lights'
      long_desc <<-LONGDESC
      Examples: \n
        hue all_lighats on \n
        hue all_lighats off \n
        hue all_lighats --hue 12345  \n
        hue all_lighats --bri 25 \n
        hue all_lighats --hue 50000 --bri 200 --sat 240 \n
      LONGDESC
      option :hue, :type => :numeric
      option :sat, :type => :numeric, :aliases => '--saturation'
      option :bri, :type => :numeric, :aliases => '--brightness'
      def all_lights(state = 'on')
        body = options.dup.to_h
        body[:on] = state == 'on'
        HueHome::Utilities::HashHelper.new(body).symbolize_keys!
        client.lights.each do |light|
          puts light.set_state(body)
        end
      end

      desc 'all_groups ON|OFF', 'Set the state of all groups'
      long_desc <<-LONGDESC
      Examples: \n
        hue all_groups on \n
        hue all_groups off \n
        hue all_groups --hue 12345  \n
        hue all_groups --bri 25 \n
        hue all_groups --hue 50000 --bri 200 --sat 240 \n
      LONGDESC
      option :hue, :type => :numeric
      option :sat, :type => :numeric, :aliases => '--saturation'
      option :bri, :type => :numeric, :aliases => '--brightness'
      def all_groups(state = 'on')
        body = options.dup.to_h
        body[:on] = state == 'on'
        HueHome::Utilities::HashHelper.new(body).symbolize_keys!
        client.groups.each do |group|
          puts group.set_state(body)
        end
      end

      desc 'all_groups_crazy', 'Turn on all groups and have the lights change constantly'
      long_desc <<-LONGDESC
      Examples: \n
        hue all_groups_crazy
      LONGDESC
      option :hue, :type => :numeric
      option :sat, :type => :numeric, :aliases => '--saturation'
      option :bri, :type => :numeric, :aliases => '--brightness'
      def all_groups_crazy
        body = options.dup.to_h
        body[:on] = state == 'on'
        HueHome::Utilities::HashHelper.new(body).symbolize_keys!
        client.groups.each do |group|
          puts group.go_crazy!
        end
      end

      private

      def client
        @client ||= HueHome.client(command_line: true)
      end
    end
  end
end
