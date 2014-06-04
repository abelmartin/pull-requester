class GithubClientWrapper
  def self.get_json
    load_github_config
    @config_yml.to_json
  end

  def self.get_client(gh_token, subdomain = nil)
    load_github_config
    client_config = {oauth_token: gh_token, auto_pagination: true}

    unless ['', 'www', 'local'].include? subdomain
      client_config.merge!( @config_yml )
    end

    Github.new(client_config)
  end

  private

  def self.load_github_config
    return if @config_yml

    if File.exists?("#{Rails.root}/config/github_api_enterprise_config.yml")
      @config_yml = YAML.load_file "#{Rails.root}/config/github_api_enterprise_config.yml"
    elsif ENV['GITHUB_API_CONFIG']
      @config_yml = JSON.parse ENV['GITHUB_API_CONFIG']
    else
      @config_yml = {}
    end

    @config_yml = @config_yml.with_indifferent_access
  end
end