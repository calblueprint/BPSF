
var phrasing_setup = function(){

  // Initialize the editing bubble
  editor.init();

  // Making sure to send csrf token from layout file.
  $(document).ajaxSend(function(e, xhr, options) {
    var token = $("meta[name='csrf-token']").attr("content");
    xhr.setRequestHeader("X-CSRF-Token", token);
  });

  // Hash size function
  Object.size = function(obj){
    var size = 0, key;
    for (key in obj) { if (obj.hasOwnProperty(key)) size++; }
    return size;
  };

  // Trigger AJAX on textchange
  var trigger_binded_events_for_phrasable_class = 1;
  var timer = {}
  var timer_status = {}

  $('.phrasable').on('DOMNodeInserted DOMNodeRemoved DOMCharacterDataModified', function(e){

    $('#phrasing-edit-mode-bubble #phrasing-saved-status-headline p').text("Saving")
    $('#phrasing-saved-status-indicator-circle').css('background-color', 'orange')

    if (trigger_binded_events_for_phrasable_class == 1){

      var record = this;

      clearTimeout(timer[$(record).data("url")]);
      timer_status[$(record).data("url")] = 0;

      timer[$(record).data("url")] = setTimeout(function(){
        savePhraseViaAjax(record);
        delete timer_status[$(record).data("url")]
      },2500)
      timer_status[$(record).data("url")] = 1;
    }

  });

  // AJAX Request
  function savePhraseViaAjax(record){

    var url = $(record).data("url");

    var content = record.innerHTML;

    if(content.length == 0){
      content= "Empty"
    }

    $.ajax({
      type: "PUT",
      url: url,
      data: { new_value: content },
      success: function(e){
        trigger_binded_events_for_phrasable_class = 0;
        if(content == "Empty"){
          $('span.phrasable[data-url="'+ url +'"]').html(content)
        }else{
          $('span.phrasable[data-url="'+ url +'"]').not(record).html(content)
        }
        trigger_binded_events_for_phrasable_class = 1;

        if (Object.size(timer_status) == 0){
          $('#phrasing-edit-mode-bubble #phrasing-saved-status-headline p').text("Saved")
          $('#phrasing-saved-status-indicator-circle').css('background-color', '#56AE45')
        }
      },
      error: function(e){
        $('#phrasing-edit-mode-bubble #phrasing-saved-status-headline p').text("Error")
        $('#phrasing-saved-status-indicator-circle').css('background-color', 'red')
      }
    });
  }

  // Edit Mode On/Off Button
  $('#edit-mode-onoffswitch').on('change', function(){
    if(this.checked){
      $('.phrasable').addClass("phrasable_on").attr("contenteditable", "true");
      $.cookie("editing_mode", "true");
    }
    else{
      $('.phrasable').removeClass("phrasable_on").attr("contenteditable", "false");
      $.cookie("editing_mode", "false");
    }
  });

  if($.cookie("editing_mode") == null){
    $.cookie("editing_mode", "true");
    $('#edit-mode-onoffswitch').prop('checked', true)
  }
  else if($.cookie("editing_mode") == "true"){
    $('#edit-mode-onoffswitch').prop('checked', true)
  }else{
    $('#edit-mode-onoffswitch').prop('checked', false)
  }

};

$(document).ready(phrasing_setup);
