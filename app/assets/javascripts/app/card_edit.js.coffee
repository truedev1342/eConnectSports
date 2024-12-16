jQuery(document).ready ->
  if $('#card_url_alias').length > 0
    $('#card_url_alias').tooltip
      title: 'This alias is already in use or disallowed'
      trigger: 'manual'
    check_card_url_alias()

    $('#card_url_alias').click ->
      return !alias_valid

  if $('.select-from-library').length > 0
    $('.select-from-library').click ->
      $('#images-library').modal('show')

    # fit images
    ratio = 1.7
    $('#images-library img').each ->
      $this = $(this)
      imgPath = $this.attr('src')
      imgEle = new Image
      imgEle.src = imgPath
      imgEle.addEventListener 'load', ->
        imgClass = 'tall'
        if @width / @height > ratio
          imgClass = 'wide'
        $this.addClass imgClass
        return
      return

    #click on image from library
    $('#images-library .image-container').click ->
      $this = $(this)
      $('#images-library .image-container').removeClass('selected')
      $this.addClass('selected')
      image_name = $this.data('image')
      image_url = $this.find('img').attr('src')
      arr = image_url.split("/")
      image_url = "/" + arr.slice(3,arr.length).join('/')
      $('input[name=library_image]').val image_url
      $('#card_library_image, .box.background input[type=text],.modal.in .bottom-block .field input[type=text], .background_field input[type=text]').val(image_name)


current_alias = ""
alias_valid = true
check_card_url_alias =()->
  current_alias = $('#card_url_alias').val()
  $('#card_url_alias').keyup ->
    text = $('#card_url_alias').val()
    text = clean_string(text)
    $('#card_url_alias').val(text)
    if text != current_alias && text != ""
      $.ajax(
        type: 'post',
        url: '/cards/check_url_alias',
        data: {url_alias: text},
        success: check_if_busy
      )
    else
      check_if_busy({result: 'free'})
    current_alias = text
    return

check_if_busy =(data)->
  if data.result == 'busy'
    $('#card_url_alias:focus').css('border-color', 'rgb(236, 82, 82)')
    $('#card_url_alias').tooltip('show')
    alias_valid = false
  else
    $('#card_url_alias:focus').css('border-color', 'rgba(82,168,236,0.8)')
    $('#card_url_alias').tooltip('hide')
    alias_valid = true

clean_string =(text)->
  text = text.replace(/https?:\/\//g, '')
  text.replace(/[\/\?&'"\(\)]/g, '')
