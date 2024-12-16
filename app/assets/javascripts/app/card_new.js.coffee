$(document).ready ->
  if $('.new-card-block').length > 0
    firstTab()
    $('.new-card-block .next').click ->
      currentTab = $('.step-tab:visible').data("tab")
      activateTab(currentTab + 1, currentTab)

    $('.new-card-block .back').click ->
      currentTab = $('.step-tab:visible').data("tab")
      activateTab(currentTab - 1, currentTab)

    $('.finish').click ->
      $('.card-form')[0].submit()

activateTab =(new_tab, old_tab)->
  if new_tab == 1
    firstTab()
  else if new_tab == 4
    lastTab()
  else
    middleTab()

  $('.step' + old_tab).hide()
  $('.step' + new_tab).show()

firstTab =->
  $('.finish, .back').hide()
  $('.next').show()

middleTab =->
  $('.finish').hide()
  $('.next, .back').show()

lastTab =->
  $('.next').hide()
  $('.finish, .back').show()
