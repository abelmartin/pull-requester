class GithubClientWrapper
  def self.get_json
    load_github_config
    @yml.to_json
  end

  def self.configuration
    load_github_config
    @yml
  end

  def self.get_client(gh_token, subdomain = nil)
    load_github_config

    if subdomain.blank? || subdomain == 'www' || @yml[subdomain].nil?
      Github.new(oauth_token: gh_token, auto_pagination: true)
    else
      Github.new(
        oauth_token: gh_token,
        auto_pagination: true,
        endpoint: @yml[subdomain]['client_options']['api_url'],
        site: @yml[subdomain]['client_options']['site'],
        adapter: :net_http,
        ssl: {verify: false}
      )
    end
  end

  private

  def self.load_github_config
    return if @yml

    if File.exists?("#{Rails.root}/config/github_credentials.yml")
      @yml = YAML.load_file "#{Rails.root}/config/github_credentials.yml"
    else
      @yml = JSON.parse ENV['GITHUB_CREDENTIALS']
    end

    @yml = @yml.with_indifferent_access
  end
end