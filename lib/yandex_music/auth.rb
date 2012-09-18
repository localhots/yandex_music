module YandexMusic
  module Auth

    def authenticate(login, password)
      response = http.post "https://oauth.yandex.ru/token", {
        grant_type: "password",
        client_id: @client_id,
        client_secret: @client_secret,
        username: login,
        password: password
      }

      result = ::JSON.parse(response.body)
      return false if result["access_token"].nil?

      http.headers["Authorization"] = "OAuth " << result["access_token"]
      true
    end

  end
end
