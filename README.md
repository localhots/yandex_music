# Ruby-обертка для несуществующего API Яндекс.Музыки

Реализованы методы:
+ search
+ artist_albums
+ albums_tracks

## Installation

Add this line to your application's Gemfile:
```ruby
gem "yandex_music"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install yandex_music
```

## Usage

```ruby
require "yandex_music"
client = YandexMusic::Client.new(CLIENT_ID, CLIENT_SECRET)
client.authenticate(YANDEX_LOGIN, YANDEX_PASSWORD)

# Search for artist
response = client.search(text: "Queen", type: "artist", nocorrect: true, page: 0, region: "225mp")
queen = response[:search][:artists].first

# Get albums list
response = client.artist_albums(artist_id: 79215, sort: "rating", region: "225mp")
the_miracle = response[:albums][13]

# Get tracks
response = client.albums_tracks(album_id: 295710, region: "225mp")
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
