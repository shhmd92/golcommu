$(function () {
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
  $("#event_img").change(function () {
    readURL(this);
  });
});

$(function () {
  $('#place_id').autocomplete({
    //autoFocus: true,
    source: "/events/autocomplete_search.json",
    minLength: 2,
    focus: function (event, ui) {
      $("#place_id").val(ui.item.value);
      return false;
    },
    select: function (event, ui) {
      var course_id = ui.item.value;
      var course_name = ui.item.value;

      var last_index = course_id.lastIndexOf('[');
      course_id = course_id.substring(last_index + 1, course_id.length - 1);
      $('#course_id').val(course_id);

      course_name = course_name.substring(0, last_index);
      $('#place_id').val(course_name);
      return false;
    }
  }).data("ui-autocomplete")._renderItem = function (ul, item) {
    return $("<li>").attr("data-value", item.value).data("ui-autocomplete-item", item).append("<a>" + item.value + "</a>").appendTo(ul);
  };
});

$(function () {
  $('#place_id').focusout(function () {
    var course_id = $('#course_id').val();
    $.ajax({
        url: '/events/golf_course_info',
        type: 'GET',
        data: ('course_id=' + course_id),
        processData: false,
        contentType: false,
        dataType: 'json'
      })
      .done(function (data) {
        $('#address_field').val(data['address']);
        $('#img_prev').attr('src', data['golf_course_image_url']);
        $('#event_remote_image_url').val(data['golf_course_image_url']);
      })
      .fail(function () {});
  });
});

$(function () {
  $("#input-content-area")
    .on("keydown keyup keypress change", function () {
      let countNonBrNum = String($(this).val().replace(/[\n\r]/g, "").length);
      if (countNonBrNum > 0) {
        sendBtnDisabled(false);
      } else {
        sendBtnDisabled(true);
      }

      let countNum = String($(this).val().length);
      if (countNum > 240) {
        $("#content-counter").text("文字数オーバーです");
        sendBtnDisabled(true);
      } else {
        $("#content-counter").text("");
        if (countNonBrNum > 0) {
          sendBtnDisabled(false);
        }
      }
    });
});