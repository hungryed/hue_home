module HueHome
  module ConnectionBuilder
    def build_connection(base_url:)
      Faraday.new(url: base_url) do |faraday|
        faraday.request  :url_encoded
        faraday.response :logger if HueHome.configuration.debug
        faraday.adapter  Faraday.default_adapter
      end
    end
  end
end
