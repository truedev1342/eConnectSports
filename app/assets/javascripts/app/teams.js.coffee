jQuery(document).ready ->
  $("body").on "change","input[type='checkbox'].send_to", (e)->
    $("#send_message_to").val("")
    $("input[type='checkbox'].send_to").each ()->
      if $(this).is(':checked')
        send_to_id = $(this).val()
        if $("#send_message_to").val() == ""
          $("#send_message_to").val(send_to_id)
        else
          $("#send_message_to").val($("#send_message_to").val() + ",#{send_to_id}")

  $("body").on "submit","#send_message_to_team", (e)->
    $("#send_message_error").text("")
    if $("#send_message_to").val() == ""
      e.preventDefault()
      $("#send_message_error").text("Please select the recipient")
