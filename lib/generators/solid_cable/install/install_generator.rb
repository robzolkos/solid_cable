# frozen_string_literal: true

class SolidCable::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def add_solid_errors_db_schema
    template "db/cable_schema.rb"
  end

  def configure_production_cable
    gsub_file("config/cable.yml",
              /production:\n(^\s*.*$\n){2,}/,
              new_production_cable_config)
  end

  private

  def new_production_cable_config
    <<~YAML
      production:
        adapter: solid_cable
        connects_to:
          database:
            writing: cable
        polling_interval: 0.1.seconds
        keep_messages_around_for: 1.day
    YAML
  end
end
