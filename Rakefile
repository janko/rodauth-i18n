# frozen_string_literal: true

require "bundler/gem_tasks"
require "rodauth"
require "yaml"

task :import do
  translations = {}

  Rodauth::Feature.prepend Module.new {
    define_method :translatable_method do |meth, value|
      super(meth, value)
      translations[meth.to_s] = value
    end
  }

  spec = Gem::Specification.find_by_name("rodauth")
  features_pattern = File.join(spec.full_gem_path, "lib/rodauth/features/*.rb")
  Dir[features_pattern].each { |path| load(path) }

  translation_data = { "en" => { "rodauth" => translations.sort.to_h } }
  locale_content = YAML.dump(translation_data, line_width: 1000)
  locale_content = locale_content.split("\n", 2).last # exclude "---"

  File.write("locales/en.yml", locale_content)
end
