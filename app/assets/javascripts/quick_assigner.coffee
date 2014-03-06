class window.QuickAssigner
  start: ->
    self = @
    $('select.chosen').chosen
      no_results_text: 'No members match.  Try again, dude'
      placeholder_text_single: 'Assign a team member'
      allow_single_deselect: true

    $('select.chosen').on 'change', (evt, selected_option) ->
      self.assign_user(evt, selected_option)

  assign_user: (evt, selected_option) ->
    console.log selected_option
    $select = $(evt.currentTarget)
    $td_avatar = $select.parents('td.avatar')
    pull_number = $select.data('pullNumber')

    if selected_option
      new_assignee_login = selected_option.selected
      $selectedOption = $('option[value='+new_assignee_login+']', $select)
      new_avatar_url = $selectedOption.data('avatarUrl')
    else
      new_assignee_login = ''
      new_avatar_url = ''

    $.ajax
      type: 'PUT'
      url: "/repositories/#{$select.data('repositoryId')}/assign_user/"
      data: {assignee_login: new_assignee_login, pull_number: pull_number}
      dataType: 'json'
      beforeSend: ->
        $td_avatar.find('img.avatar').attr('src', '/images/loader.gif')
      success: ->
        $td_avatar.find('img.avatar').attr('src', new_avatar_url)
        $td_avatar.find('.pr_assignee').html(new_assignee_login || 'Unassigned')
      error: ->
        alert "An error occurred!  Please refresh this page and try again."
