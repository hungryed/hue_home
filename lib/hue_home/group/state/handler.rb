module HueHome
  module Group
    module State
      class Handler
        attr_reader :bridge, :group, :initial_state
        include HueHome::Connection
        include HueHome::History::Helper
        url(:set_state, :put) { |current_user_id, id| "/api/#{current_user_id}/groups/#{id}/action" }
        BRIGHTNESS_RANGE = (1..254).to_a
        HUE_RANGE = (0..65535).to_a
        SATURATION_RANGE = (0..254).to_a
        CT_RANGE = (153..500).to_a
        TRANSITION_TIME_RANGE = (1..30).to_a

        def initialize(bridge:, group:, initial_state:)
          @bridge = bridge
          @group = group
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
          response.body
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

        def id
          @id ||= group.id
        end

        def current_user_id
          @current_user_id ||= bridge.current_user_id
        end
      end
    end
  end
end
