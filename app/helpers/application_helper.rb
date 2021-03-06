module ApplicationHelper
  def circle_ci_badge(owner, repo, branch)
    unknown_image_url = asset_path('status_unknown_2.png', type: :image)

    base_url = "https://circleci.com/gh/#{owner}/"
    full_url = "#{base_url}#{u(repo)}/tree/#{u(branch)}"
    badge_url = "#{full_url}.png"
    link_to(full_url, target: '_blank') do
      image_tag(
        badge_url,
        onerror: "this.onerror=null;this.src='#{unknown_image_url}'"
      )
    end
  end

  def travis_ci_badge(owner, repo, branch=nil)
    "https://travis-ci.org/#{owner}/#{repo}.png"
  end

  def render_markdown(md_text)
    content = GitHub::Markdown.render_gfm(emojify_to_markdown(md_text))

    # I'm not in love with this.
    # I might go with <base target="_blank"> in head later
    # And try to force <...target="_parent"...> later :-/
    content.gsub(/(href=".*")/, '\1 target="_blank" ').html_safe
  end

  def emojify_to_markdown(md_text)
    if md_text.present?
      md_text.gsub(/:([a-z0-9\+\-_]+):/) do |match|
        if Emoji.names.include?($1)
          "![#{$1}](/images/emoji/#{$1}.png 'emoji')"
        else
          match
        end
      end
    else
      ''
    end
  end

  def user_or_repo_href(org)
    if (current_user.github_login != org[:login])
      "/repositories?org=#{org[:login]}"
    else
      "/repositories?user=#{org[:login]}"
    end
  end
end
