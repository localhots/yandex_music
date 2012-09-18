module YandexMusic
  class AppHttpClient < Faraday::Middleware

    def call(env)
      env[:request_headers]["User-Agent"] = "YandexMusic/33 CFNetwork/548.1.4 Darwin/11.0.0"
      env[:request_headers]["Accept"] = "*/*"
      env[:request_headers]["Content-Type"] = "application/x-www-form-urlencoded"
      env[:request_headers]["Accept-Language"] = "en-us"
      env[:request_headers]["Accept-Encoding"] = "gzip, deflate"
      env[:request_headers]["Connection"] = "keep-alive"
      env[:request_headers]["Proxy-Connection"] = "keep-alive"

      @app.call(env)
    end

  end
end
