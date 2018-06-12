module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :val
    config.i18n.available_locales = [:en, :es, :val]
    config.i18n.fallbacks = {'val' => 'es', 'en' => 'es'}
  end
end
