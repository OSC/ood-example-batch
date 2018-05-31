require 'pathname'
require 'ood_support'
require 'dotenv/load'

class ConfigurationSingleton
  def portal
    ENV["ONDEMAND_PORTAL"] || "ondemand"
  end

  def portal_title
    ENV["ONDEMAND_TITLE"] || "OnDemand"
  end

  def current_user
    OodSupport::User.new
  end

  # The app's root directory
  # @return [Pathname] path to app root
  def app_root
    Pathname.new(File.expand_path("../../",  __FILE__))
  end

  def dataroot
    Pathname.new(
      ENV.fetch("OOD_DATAROOT",
        if rails_env == "production"
          "~/#{portal}/data/#{app_token}"
        else
          "data"
        end
      )
    ).expand_path
  end

  def job_prefix
    ENV["JOB_PREFIX"] || "#{portal}/#{app_token}"
  end

  def script_name
    ENV["SCRIPT_NAME"] || "main.sh"
  end

  def database_path
    Pathname.new(
      ENV.fetch("DATABASE_PATH",
        if rails_env == "production"
          dataroot.join("production.sqlite3")
        else
          "db/#{rails_env}.sqlite3"
        end
      )
    )
  end

  private

  # The environment
  # @return [String] "development", "test", or "production"
  def rails_env
    ENV['RAILS_ENV'] || ENV['RACK_ENV'] || "development"
  end

  def app_type
    if rails_env == "production"
      app_owner == "root" ? "sys" : "usr"
    else
      "dev"
    end
  end

  def app_owner
    OodSupport::User.new(ENV["APP_OWNER"] || app_root.stat.uid)
  end

  def app_name
    ENV["APP_NAME"] || app_root.basename
  end

  def app_token
    [
      app_type,
      app_type == "sys" ? nil : app_owner,
      app_name
    ].compact.join("/")
  end

  FALSE_VALUES=[nil, false, '', 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF', 'no', 'NO']

  # Bool coersion pulled from ActiveRecord::Type::Boolean#cast_value
  #
  # @return [Boolean] false for falsy value, true for everything else
  def to_bool(value)
    ! FALSE_VALUES.include?(value)
  end
end
