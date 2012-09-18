require "rubygems"
require "bundler/setup"
require "nokogiri"
require "ap"

xml = Nokogiri::XML(File.open("spec/fixtures/albums_tracks.xml").read)
album = xml.children.first

def parse_time(string)
  Time.new(*string.scan(/\d+/).slice(0, 6).map(&:to_i), string.match(/[+-]{1}\d{2}:\d{2}/)[0]).utc
end

result = {}

ap result
