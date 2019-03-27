# frozen_string_literal: true

module Google
  module Maps
    class AddressComponentsProxy
      def initialize(address_components)
        @address_components = address_components
      end

      def method_missing(method_name, *args)
        raise ArgumentError unless args.empty?

        @address_components.find do |component|
          component.types.first == method_name.to_s
        end || super
      end

      def respond_to_missing?(method_name, include_private = false)
        @address_components.any? do |component|
          component.types.first == method_name.to_s
        end || super
      end
    end
  end
end
