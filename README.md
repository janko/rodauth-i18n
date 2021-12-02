# rodauth-i18n

Provides [I18n] integration for [Rodauth] authentication framework.

It also includes built-in translations for various languages, which you are encouraged to extend :pray:

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rodauth-i18n"
```

And then execute:

```sh
$ bundle install
```

Or install it yourself as:

```sh
$ gem install rodauth-i18n
```

## Usage

Enable the `i18n` feature in your Rodauth configuration:

```rb
plugin :rodauth do
  enable :i18n
  # ...
end
```

This will make translations go through the [I18n] gem, and will automatically load translations for locales specified in `I18n.available_locales` (if unset, translations for *all* locales will be loaded).

### Per configuration translations

If you want to translate differently for different Rodauth configurations, you can define translations under the namespace matching the configuration name:

```rb
plugin :rodauth, name: :admin do
  enable :i18n
  # ...
end
```
```yml
en:
  rodauth:
    admin:
      create_account_button: Create Admin Account
```

You can change the translation namespace via the `i18n_namespace` setting:

```rb
plugin :rodauth, name: :superadmin do
  enable :i18n
  i18n_namespace "admin"
end
```

Any translations that are not found under the configuration namespace will fall back to top-level. If you want to disable this behaviour, you can do so via the `i18n_cascade?` setting:

```rb
i18n_cascade? false
```

### Copying translations

In a Rails app, you can copy built-in translations into your app via the `rodauth:i18n:translations` generator, which receives a list of locales to copy translations for:

```sh
$ rails generate rodauth:i18n:translations en hr
# create  config/locales/rodauth.en.yml
# create  config/locales/rodauth.hr.yml
```

On other web frameworks, you can copy the translation files directly from the `locales/` directory.

### Raising on missing translations

You can tell I18n to raise an error when a translation is missing:

```rb
i18n_raise_on_missing_translations? { Rails.env.test? }
```

### Falling back to untranslated value

In some cases it can be useful to fall back to untranslated value when the translation is missing:

```rb
i18n_fallback_to_untranslated? { Rails.env.production? }
```

### Overriding current locale

The current locale defaults to `I18n.locale`, but you can override that:

```rb
i18n_locale :en
```

### Custom I18n options

You can pass any custom options to the `I18n.translate` method via `i18n_options`:

```rb
i18n_options { { exception_handler: -> (*args) { ... } } }
```

## Localized routes

If you want to prefix your routes with current locale, you can do so as
follows:

```rb
prefix do
  if I18n.locale == I18n.default_locale
    "/auth"
  else
    "/#{I18n.locale}/auth"
  end
end
```
```rb
route do |r|
  # ...
  all_locales = I18n.available_locales.map(&:to_s) - [I18n.default_locale.to_s]
  # routes requests starting with `(/:locale)/auth/*`
  r.on [*all_locales, true], "auth" do |locale|
    rails_request.params[:locale] = locale || I18n.default_locale # if using Rails
    r.rodauth
    break
  end
end
```

## Bundling translations in your Rodauth plugin

To make texts in your Rodauth plugin translatable, use the `translatable_method` macro. Macros for defining flash messages, button texts, and page titles internally call `translatable_method`, and are thus automatically translatable.

```rb
# lib/rodauth/features/foo.rb
module Rodauth
  Feature.define(:foo, :Foo) do
    translatable_method :foo_message, "This message is translatable"
    error_flash "Flash messages are automatically translatable", "foo"
    button "Translatable button text", "foo"
    view "foo", "Translatable page title", "foo"
  end
end
```

You can then define translations in the `locales/` directory in your gem root:

```yml
# locales/en.yml
en:
  rodauth:
    foo_message: "..."
    foo_error_flash: "..."
    foo_button: "..."
    foo_page_title: "..."
```

Then, to have rodauth-i18n load your translations, register the directory when loading the feature:

```rb
# lib/rodauth/features/foo.rb
module Rodauth
  Feature.define(:foo, :Foo) do
    # ...
    def post_configure
      super
      i18n_register File.expand_path("#{__dir__}/../../../locales") if features.include?(:i18n)
    end
    # ...
  end
end
```

## Development

Run tests with Rake:

```sh
$ bundle exec rake test
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/janko/rodauth-i18n. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/janko/rodauth-i18n/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the rodauth-i18n project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/janko/rodauth-i18n/blob/master/CODE_OF_CONDUCT.md).

[I18n]: https://github.com/ruby-i18n/i18n
[Rodauth]: https://github.com/jeremyevans/rodauth
[Rails Internationalization Guide]: https://guides.rubyonrails.org/i18n.html
