// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// This doesn't affect the behavior of the app right now. This is in 
// the issue tracking system.

$(function() {
  $(".todo-list-item li").click(function(){
    $(this).children('.task-details').css('display', 'inherit');
  });
});
