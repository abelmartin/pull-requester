module ApplicationHelper
  def circle_ci_badge(repo, branch)
    base_url = 'https://circleci.com/gh/howaboutwe/'
    full_url = "#{base_url}#{repo}/tree/#{branch}"
    badge_url = "#{full_url}.png"
    link_to(full_url, target: '_blank') do
      image_tag badge_url
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
