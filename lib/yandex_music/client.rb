module YandexMusic
  class Client
    include YandexMusic::Auth
    include YandexMusic::Endpoints::Search
    include YandexMusic::Endpoints::ArtistAlbums
    include YandexMusic::Endpoints::AlbumsTracks

    def initialize(client_id, client_secret)
      @client_id, @client_secret = client_id, client_secret
    end

  private

    def http
      @faraday ||= Faraday.new do |faraday|
        faraday.request  :url_encoded               # form-encode POST params
        faraday.adapter  Faraday.default_adapter    # make requests with Net::HTTP
        faraday.use      YandexMusic::AppHttpClient # run requests through app emulator
      end
    end

    def prepared(params)
      params.inject({}) do |result, (key, value)|
        result[key.to_s.gsub("_", "-")] = value
        result
      end
    end

    def parse_time(string)
      Time.new(*string.scan(/\d+/).slice(0, 6).map(&:to_i), string.match(/[+-]{1}\d{2}:\d{2}/)[0]).utc
    end

  end
end
