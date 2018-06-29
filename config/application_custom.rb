module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :val
    config.i18n.available_locales = [:val, :es, :en, :fr, :nl, 'pt-BR']
    config.i18n.fallbacks = {'val' => 'es', 'fr' => 'es', 'pt-br' => 'es', 'nl' => 'en'}
  end
end
