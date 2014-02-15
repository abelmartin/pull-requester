class window.ToggleRepositoryWatch
  constructor: (@$form, @allow_remove = true) ->
    @$td = $(@$form.parents('td'))

    console.log(@$form)
    console.log(@$td)
    console.log(@allow_remove)

    @$form.submit (e) =>
      e.preventDefault()

      if @$form.hasClass('remove_repository')
        @remove_repository({type:'DELETE'})
      else if @$form.hasClass('add_repository')
        @add_repository({type:'POST'})

  add_repository: (options) =>
    $.ajax(
      type: options.type
      url: @$form.attr('action')
      dataType: 'json'
      data: @$form.serialize()
      success: =>
        @$form.removeClass('active')
        @$td.find('.remove_repository').addClass('active')
    )

  remove_repository: (options) =>
    $.ajax(
      type: options.type
      url: @$form.attr('action')
      dataType: 'json'
      data: @$form.serialize()
      success: =>
        @$form.removeClass('active')
        @$td.find('.add_repository').addClass('active')
    )
