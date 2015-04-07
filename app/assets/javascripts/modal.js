var hideModal = function() {
  $("#submit-button").click(function() {
    //$(this).parent().parent().parent().parent().parent().remove();
    $(".modal-content").remove();
  });
};
