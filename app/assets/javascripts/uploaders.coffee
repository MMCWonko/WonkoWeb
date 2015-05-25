window.togglePasswordShown = (button) ->
  btn = $(button)
  input = btn.parent().parent().find 'input'
  if input.attr('type') == 'password'
    input.attr 'type', 'text'
    btn.html 'Hide'
  else
    input.attr 'type', 'password'
    btn.html 'Show'
  return false
