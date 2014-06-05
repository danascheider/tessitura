// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $("button").click(function() {
    var tr = $(this).parents("tr");
    $.ajax({
      url: '/tasks',
      content: document.body
    }).done(function() {
      tr.fadeOut()
    });
  })
});
