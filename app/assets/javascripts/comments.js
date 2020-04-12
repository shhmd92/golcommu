$(function () {
  $("#input-content-area")
    .on("change keyup keydown paste cut", function () {
      if ($(this).outerHeight() > this.scrollHeight) {
        $(this).height(60)
      }
      while ($(this).outerHeight() < this.scrollHeight) {
        $(this).height($(this).height() + 1)
      }
    });

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

function sendBtnDisabled(bol) {
  if (bol) {
    $("#send-comment").prop("disabled", true);
    $("#send-comment").css("cursor", "not-allowed");
  } else {
    $("#send-comment").prop("disabled", false);
    $("#send-comment").css("cursor", "pointer");
  }
}