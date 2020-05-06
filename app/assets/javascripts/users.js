$(function () {
  $('#update').tooltip()
});

$(function () {
  $('#delete').tooltip()
});

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
  $("#user_img").change(function () {
    readURL(this);
  });
});

$(function () {
  var index = 0;

  if (window.performance) {
    if (performance.navigation.type === 1 || performance.navigation.type === 2) {
      if ($.cookie('index')) {
        index = $.cookie('index');
        $('#profile-tablist li a').eq(index).addClass('active');
        $('#profile-tabContent .tab-pane').eq(index).addClass('show active');
      }
    } else {
      $.cookie('index', index);
      $('#profile-tablist li:first-child a').addClass('active');
      $('#profile-tabContent .tab-pane:first-child').addClass('show active');
    }
  }

  $('#profile-tablist li').click(function () {
    if (index != $('#profile-tablist li').index(this)) {
      index = $('#profile-tablist li').index(this);
      $.cookie('index', index);
    }
  });
});