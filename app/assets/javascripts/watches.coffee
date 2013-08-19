class ToggleWatch
  constructor: (@$form, @allow_remove = true) ->
    @$td = $(@$form.parents('td'))

    console.log(@$form)
    console.log(@$td)
    console.log(@allow_remove)

    @$form.submit (e) =>
      e.preventDefault()

      if @$form.hasClass('remove_watch')
        @remove_watch({type:'DELETE'})
      else if @$form.hasClass('add_watch')
        @add_watch({type:'POST'})

  add_watch: (options) =>
    $.ajax(
      type: options.type
      url: @$form.attr('action')
      data: {watch: {
        repo_id: @$form.data('repo-id')
        repo_name: @$form.data('repo-name')
        repo_owner: @$form.data('repo-owner')
      }}
      success: =>
        @$form.removeClass('active')
        @$td.find('.remove_watch').addClass('active')
    )

  remove_watch: (options) =>
    console.log(@$form.data())
    debugger

window.ToggleWatch = ToggleWatch
