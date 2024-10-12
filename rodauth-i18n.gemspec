# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "rodauth-i18n"
  spec.version       = "0.8.0"
  spec.authors       = ["Janko Marohnić"]
  spec.email         = ["janko@hey.com"]

  spec.summary       = "Provides I18n integration and translations for Rodauth authentication framework."
  spec.homepage      = "https://github.com/janko/rodauth-i18n"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.5"

  spec.files         = Dir["README.md", "LICENSE.txt", "CHANGELOG.md", "lib/**/*", "locales/**/*", "*.gemspec"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rodauth", "~> 2.19"
  spec.add_dependency "i18n", "~> 1.0"

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-hooks"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "tilt"
  spec.add_development_dependency "bcrypt"
end
