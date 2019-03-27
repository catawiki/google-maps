# frozen_string_literal: true

require File.expand_path('api', __dir__)
require File.expand_path('address_components_proxy', __dir__)

module Google
  module Maps
    class Place
      attr_reader :text, :html, :keyword, :place_id
      alias to_s text
      alias to_html html

      def initialize(data, keyword)
        @text = data.description
        @place_id = data.place_id
        @html = highligh_keywords(data, keyword)
      end

      def self.find(keyword, language = :en)
        args = { language: language, input: keyword }
        API.query(:places_service, args).predictions.map { |prediction| Place.new(prediction, keyword) }
      end

      private

      def highligh_keywords(data, keyword)
        keyword = Regexp.escape(keyword)
        matches = Array(keyword.scan(/\w+/))
        html = data.description.dup
        matches.each do |match|
          html.gsub!(/(#{match})/i, '<strong>\1</strong>')
        end

        html
      end
    end

    class PlaceDetails
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def latitude
        @data.geometry.location.lat.to_s
      end

      def longitude
        @data.geometry.location.lng.to_s
      end

      def place_id
        @data.place_id
      end

      def address
        @data.formatted_address
      end
      alias to_s address

      def address_components
        AddressComponentsProxy.new(@data.address_components)
      end

      def self.find(place_id, language = :en)
        args = { language: language, placeid: place_id }
        PlaceDetails.new(API.query(:place_details_service, args).result)
      end
    end
  end
end
