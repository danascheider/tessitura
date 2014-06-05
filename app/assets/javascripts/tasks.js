// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// This doesn't affect the behavior of the app right now. This is in 
// the issue tracking system.

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
