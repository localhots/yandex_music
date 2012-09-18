module YandexMusic
  module Endpoints
    module AlbumsTracks

      # Mandatory params:
      #   album_id: 10370
      #   region: "225mp"
      def albums_tracks(params)
        response = http.get "https://api.music.yandex.net/api/albums-tracks", prepared(params)
        album = Nokogiri::XML.parse(response.body).children.first

        { album: {
          id: (album.attribute("id").value.to_i rescue nil),
          storage_dir: (album.attribute("storage-dir").value rescue nil),
          modified: (parse_time(album.attribute("modified").value) rescue nil),
          recent: (album.attribute("recent").value == "true" rescue nil),
          original_release_year: (album.attribute("original-release-year").value.to_i rescue nil),
          title: (album.xpath("./title[@selected='true']").text rescue nil),
          cover: {
            id: (album.xpath("./cover[@selected='true']").attribute("id").value.to_i rescue nil)
          },
          genre: {
            id: (album.xpath("./genre").attribute("id").value rescue nil),
            weight: (album.xpath("./genre").attribute("weight").value.to_i rescue nil),
            composer_top: (album.xpath("./genre").attribute("composer-top").value == "true" rescue nil),
            titles: (Hash[album.xpath("./genre/titles/title").map{ |title|
              [title.attribute("language").value.to_sym, title.text]
            }] rescue {})
          },
          muz_ru_link: ({
            album: album.xpath("./muz-ru-link").attribute("album").value,
            title: album.xpath("./muz-ru-link").attribute("title").value,
            ensemble: album.xpath("./muz-ru-link").attribute("ensemble").value,
            price: album.xpath("./muz-ru-link").attribute("price").value.to_f
          } rescue nil),
          regions: (Hash[album.xpath("./regions/region").map{ |region|
            [region.attribute("id").value, region.attribute("track-count").value.to_i]
          }] rescue {}),
          display: {
            wide_tracks: (album.xpath("./display").attribute("wide-tracks").value == "true" rescue nil),
            per_track_performers: (album.xpath("./display").attribute("per-track-performers").value == "true" rescue nil)
          },
          artist: {
            role: (album.xpath("./artist").attribute("role").value rescue nil),
            id: (album.xpath("./artist").attribute("id").value.to_i rescue nil),
            modified: (parse_time(album.xpath("./artist").attribute("modified").value) rescue nil),
            various: (album.xpath("./artist").attribute("various").value == "true" rescue nil),
            composer: (album.xpath("./artist").attribute("composer").value == "true" rescue nil),
            name: (album.xpath("./artist/name[@selected='true']").text rescue nil),
          },
          tracks: (album.xpath("./tracks/volume").map{ |volume|
            (volume.xpath("./track").map{ |track| {
              volume: (volume.attribute("id").value.to_i rescue nil),
              id: (track.attribute("id").value.to_i rescue nil),
              storage_dir: (track.attribute("storage-dir").value rescue nil),
              duration: (track.attribute("duration").value.to_i rescue nil),
              duration_millis: (track.attribute("duration-millis").value.to_i rescue nil),
              file_size: (track.attribute("file-size").value.to_i rescue nil),
              modified: (parse_time(track.attribute("modified").value) rescue nil),
              title: (track.xpath("./title[@selected='true']").text rescue nil),
              muz_ru_link: ({
                album: track.xpath("./muz-ru-link").attribute("track").value,
                title: track.xpath("./muz-ru-link").attribute("title").value,
                ensemble: track.xpath("./muz-ru-link").attribute("ensemble").value,
                price: track.xpath("./muz-ru-link").attribute("price").value.to_f
              } rescue nil),
              regions: (track.xpath("./regions/region").map{ |region| {
                id: region.attribute("id").value.to_i,
                major_id: region.attribute("major-id").value.to_i,
                major_name: region.attribute("major-name").value
              } } rescue nil),
              ownership: ({
                major_id: track.xpath("./ownership").attribute("major-id").value.to_i
              } rescue nil),
              album: {
                id: (track.xpath("./album").attribute("id").value.to_i rescue nil),
                storage_dir: (track.xpath("./album").attribute("storage-dir").value rescue nil),
                modified: (parse_time(track.xpath("./album").attribute("modified").value) rescue nil),
                recent: (track.xpath("./album").attribute("recent").value == "true" rescue nil),
                original_release_year: (track.xpath("./album").attribute("original-release-year").value.to_i rescue nil),
                title: (track.xpath("./album").xpath("./title[@selected='true']").text rescue nil),
                cover: {
                  id: (track.xpath("./album").xpath("./cover[@selected='true']").attribute("id").value.to_i rescue nil)
                },
                genre: {
                  id: (track.xpath("./album").xpath("./genre").attribute("id").value rescue nil),
                  weight: (track.xpath("./album").xpath("./genre").attribute("weight").value.to_i rescue nil),
                  composer_top: (track.xpath("./album").xpath("./genre").attribute("composer-top").value == "true" rescue nil),
                  titles: (Hash[track.xpath("./album").xpath("./genre/titles/title").map{ |title|
                    [title.attribute("language").value.to_sym, title.text]
                  }] rescue {})
                },
                muz_ru_link: ({
                  album: track.xpath("./album").xpath("./muz-ru-link").attribute("album").value,
                  title: track.xpath("./album").xpath("./muz-ru-link").attribute("title").value,
                  ensemble: track.xpath("./album").xpath("./muz-ru-link").attribute("ensemble").value,
                  price: track.xpath("./album").xpath("./muz-ru-link").attribute("price").value.to_f
                } rescue nil)
              }
            } } rescue {})
          }.inject(:+) rescue [])
        } }
      end

    end
  end
end
