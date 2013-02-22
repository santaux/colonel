$ ->
  $('#crontab-form input.all').on('click', ->
    $(this).parents(".box").find('select').attr('disabled', 'disabled')
  )

  $('#crontab-form input.multiple').on('click', ->
    $(this).parents(".box").find('select').removeAttr('disabled')
  )

  $('#crontab-form a.select_all').on('click', ->
    $(this).parents(".box").find('select option').attr('selected', 'selected')
  )

  $('#crontab-form a.clear_all').on('click', ->
    $(this).parents(".box").find('select').val(null)
  )

  $('form#crontab-form').submit( ->
    should_submit = true

    if ($('#command').val().length <= 1)
      $('#command').css('border-color', 'red')
      should_submit = false

    $('select').each( (index,select) ->
      if ($(select).val() == null)
        $(select).css('border-color', 'red')
        should_submit = false
      else
        $(select).css('border-color', '#ccc')
      console.info( select )
    )

    return should_submit
  )

  $("#command_template").on('change', ->
    $('#command').val($(this).val())
  )

  $('a').on('click', ->
    if $(this).attr('data-confirm')
      answer = confirm($(this).attr('data-confirm'))
      return false unless answer
    if $(this).attr('data-method')
      post_to_url($(this).attr('href'), $(this).attr('data-method'))
      return false
  )

  post_to_url = (path, method) ->
    form = document.createElement("form")
    form.setAttribute("method", method)
    form.setAttribute("action", path)

    document.body.appendChild(form)
    form.submit()
