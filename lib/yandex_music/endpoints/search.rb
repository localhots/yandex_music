module YandexMusic
  module Endpoints
    module Search

      # Mandatory params:
      #   text: "Queen"
      #   type: "artist"
      #   nocorrect: true
      #   page: 0
      #   region: "225mp"
      def search(params)
        response = http.get "https://api.music.yandex.net/api/search", prepared(params)
        search = Nokogiri::XML.parse(response.body).children.first

        { search: {
          type: (search.attribute("type").value rescue nil),
          page: (search.attribute("page").value.to_i rescue nil),
          text: (search.xpath("./text").text rescue nil),
          artists_total: (search.xpath("./artists").attribute("total").value.to_i rescue nil),
          artists: (search.xpath("./artists/artist").map{ |artist| {
            id: (artist.attribute("id").value.to_i rescue nil),
            various: (artist.attribute("various").value == "true" rescue nil),
            name: (artist.xpath("./name").text rescue nil),
            regions: (artist.xpath("./regions/region").map{ |region|
              region.attribute("id").value rescue nil
            } rescue []),
            popular_tracks: (artist.xpath("./popular-tracks/track").map{ |track| {
              id: (track.attribute("id").value.to_i rescue nil),
              storage_dir: (track.attribute("storage-dir").value rescue nil),
              duration_millis: (track.attribute("duration-millis").value.to_i rescue nil),
              explicit: (track.attribute("explicit").value == "true" rescue nil),
              title: (track.xpath("./title").text rescue nil),
              regions: (track.xpath("./regions/region").map{ |region|
                region.attribute("id").value rescue nil
              } rescue []),
              album: {
                id: (track.xpath("./album").attribute("id").value.to_i rescue nil),
                storage_dir: (track.xpath("./album").attribute("storage-dir").value rescue nil),
                title: (track.xpath("./album/title").text rescue nil),
                cover: {
                  id: (track.xpath("./album/cover").attribute("id").value.to_i rescue nil),
                }
              }
            } } rescue [])
          } } rescue [])
        } }
      end

    end
  end
end
