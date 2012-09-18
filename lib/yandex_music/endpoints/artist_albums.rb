module YandexMusic
  module Endpoints
    module ArtistAlbums

      # Mandatory params:
      #   artist_id: 41094
      #   sort: "rating"
      #   region: "225mp"
      def artist_albums(params)
        response = http.get "https://api.music.yandex.net/api/artist-albums", prepared(params)
        artist_albums = Nokogiri::XML.parse(response.body).children.first

        { artist: {
            id: (artist_albums.xpath("./artist").attribute("id").value.to_i rescue nil),
            various: (artist_albums.xpath("./artist").attribute("various").value == "true" rescue nil),
            composer: (artist_albums.xpath("./artist").attribute("composer").value == "true" rescue nil),
            name: (artist_albums.xpath("./artist/name[@selected='true']").text rescue nil)
          },
          pager: {
            total: (artist_albums.xpath("./pager").attribute("total").value.to_i rescue nil),
            page: (artist_albums.xpath("./pager").attribute("page").value.to_i rescue nil),
            per_page: (artist_albums.xpath("./pager").attribute("per-page").value.to_i rescue nil)
          },
          albums: (artist_albums.xpath("./album").map{ |album| {
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
            }
          } } rescue [])
        }
      end

    end
  end
end
