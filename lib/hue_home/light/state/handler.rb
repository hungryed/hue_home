require_relative "history"
require_relative "instance"

module HueHome
  module Light
    module State
      class Handler
        attr_reader :bridge, :light, :initial_state
        include HueHome::Connection
        url(:set_state, :put) { |current_user_id, id| "/api/#{current_user_id}/lights/#{id}/state" }
        BRIGHTNESS_RANGE = (1..254).to_a
        HUE_RANGE = (0..65535).to_a
        SATURATION_RANGE = (0..254).to_a
        CT_RANGE = (153..500).to_a
        TRANSITION_TIME_RANGE = (1..30).to_a

        def initialize(bridge:, light:, initial_state:)
          @bridge = bridge
          @light = light
          @initial_state = initial_state
          add_history_item(initial_state)
        end

        def on!
          set_state(on: true)
        end

        def off!
          set_state(on: false)
        end

        def undo!
          wrap_history_call do
            if state = history.undo
              set_state(**state.options, skip_history_store: true)
            end
          end
        end

        def redo!
          wrap_history_call do
            if state = history.redo
              set_state(**state.options, skip_history_store: true)
            end
          end
        end

        def go_crazy!
          on!
          loop do
            set_random_state_and_wait
          end
        end

        def set_state(skip_history_store: false, **options)
          response = request(:set_state, current_user_id, id) do |conn|
            conn.body = options.to_json
          end
          parse_and_validate_response(response)
          add_history_item(options) unless skip_history_store
          response
        end

        def set_random_state_and_wait
          options = random_options
          set_state(options)
          sleep_time = options[:transitiontime].to_f / 10.to_f
          sleep(sleep_time)
        end

        def random_options
          {
            bri: BRIGHTNESS_RANGE.sample,
            hue: HUE_RANGE.sample,
            sat: SATURATION_RANGE.sample,
            ct: CT_RANGE.sample,
            transitiontime: TRANSITION_TIME_RANGE.sample,
            xy: [rand, rand],
          }
        end

        def add_history_item(options)
          wrap_history_call do
            history.add(make_state_from(options))
          end
        end

        def wrap_history_call
          if configuration.store_light_state_history
            yield
          end
        end

        def make_state_from(options)
          Instance.new(options)
        end

        def configuration
          HueHome.configuration
        end

        def history
          @history ||= History.new
        end

        def id
          @id ||= light.id
        end

        def current_user_id
          @current_user_id ||= bridge.current_user_id
        end
      end
    end
  end
end
