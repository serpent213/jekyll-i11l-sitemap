# frozen_string_literal: true

require_relative "lib/jekyll-i11l-sitemap/version"

Gem::Specification.new do |spec|
  spec.name        = "jekyll-i11l-sitemap"
  spec.summary     = "Automatically generate an international sitemap.xml for your Jekyll site."
  spec.version     = Jekyll::I11lSitemap::VERSION
  spec.authors     = ["Steffen Beyer"]
  spec.email       = "support@213tec.com"
  spec.homepage    = "https://github.com/serpent213/jekyll-i11l-sitemap"
  spec.licenses    = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r!^bin/!) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r!^(test|spec|features)/!)
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_dependency "jekyll", ">= 3.7", "< 5.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-jekyll", "~> 0.4"
end
