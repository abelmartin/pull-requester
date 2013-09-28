BuildService.create(
  name: 'TravisCI',
  badge_pattern: 'https://travis-ci.org/{{owner}}/{{repo}}.png?branch={{branch}}'
)

BuildService.create(
  name: 'CircleCI',
  badge_pattern: 'https://circleci.com/gh/{{owner}}/{{repo}}/tree/{{branch}}'
)

puts 'BuildServices Created'
