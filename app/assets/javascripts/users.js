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
  var profile_tab_index = 0;

  if (window.performance) {
    if ($.cookie('profile_tab_index')) {
      profile_tab_index = $.cookie('profile_tab_index');
      $('#profile-tablist li a').eq(profile_tab_index).addClass('active');
      $('#profile-tabContent .tab-pane').eq(profile_tab_index).addClass('show active');
    }
  }

  $('#profile-tablist li').click(function () {
    if (profile_tab_index != $('#profile-tablist li').index(this)) {
      profile_tab_index = $('#profile-tablist li').index(this);
      $.cookie('profile_tab_index', profile_tab_index);
    }
  });
});