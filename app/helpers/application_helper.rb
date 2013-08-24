module ApplicationHelper
  def circle_ci_badge(owner, repo, branch)
    base_url = "https://circleci.com/gh/#{owner}/"
    full_url = "#{base_url}#{repo}/tree/#{branch}"
    badge_url = "#{full_url}.png"
    link_to(full_url, target: '_blank') do
      image_tag badge_url
    end
  end

  def travis_ci_badge(owner, repo, branch=nil)
    "https://travis-ci.org/#{owner}/#{repo}.png"
  end

  def render_markdown(md_text)
    @markdown ||= Redcarpet::Markdown.new(
      Redcarpet::Render::HTML.new( link_attributes: {target: '_blank'}),
      autolink: true
    )

    @markdown.render(emojify_to_markdown(md_text)).html_safe
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
      "/watches?org=#{org[:login]}"
    else
      "/watches?user=#{org[:login]}"
    end
  end

  def random_octocat_src

    octocats = %w(
      original
      orderedlistocat linktocat plumber
      octotron baracktocat
      collabocats ironcat jean-luc-picat
      spocktocat swagtocat hubot
      trekkie
    )

    "http://octodex.github.com/images/#{octocats.sample}.jpg"
  end
end
