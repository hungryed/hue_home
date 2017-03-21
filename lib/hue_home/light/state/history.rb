module HueHome
  module Light
    module State
      class History
        def current_active_value
          collection.find(&:active?)
        end

        def undo
          return unless old_value = current_active_value
          old_value_index = index_of(old_value)
          return if old_value_index == 0
          old_value.make_inactive!
          new_index = old_value_index - 1
          new_active_value = collection[new_index]
          new_active_value.make_active!
          new_active_value
        end

        def redo
          return unless old_value = current_active_value
          old_value_index = index_of(old_value)
          return if old_value == collection[-1]
          old_value.make_inactive!
          new_index = old_value_index + 1
          new_active_value = collection[new_index]
          new_active_value.make_active!
          new_active_value
        end

        def add(value)
          old_value = current_active_value
          if old_value
            old_value_index = index_of(old_value)
            collection.reject!.with_index do |element, index|
              index > old_value_index
            end
          end

          collection.each(&:make_inactive!)
          value.make_active!
          collection << value
        end

        def collection
          @collection ||= []
        end

        private

        def index_of(value)
          collection.index { |element| element === value }
        end
      end
    end
  end
end
