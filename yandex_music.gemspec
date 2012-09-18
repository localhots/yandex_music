# -*- encoding: utf-8 -*-
require File.expand_path('../lib/yandex_music/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gregory Eremin"]
  gem.email         = ["magnolia_fan@me.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "yandex_music"
  gem.require_paths = ["lib"]
  gem.version       = YandexMusic::VERSION

  gem.add_runtime_dependency "faraday"
  gem.add_runtime_dependency "nokogiri"
  gem.add_development_dependency "awesome_print"
end
