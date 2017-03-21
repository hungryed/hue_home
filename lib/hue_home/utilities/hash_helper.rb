module HueHome
  module Utilities
    class HashHelper
      attr_reader :hsh
      def initialize(hsh)
        @hsh = hsh.to_h
      end

      def symbolize_keys!
        hsh.keys.each do |key|
          value = hsh.delete(key)
          hsh[key.to_sym] = value
        end
        hsh
      end
    end
  end
end
