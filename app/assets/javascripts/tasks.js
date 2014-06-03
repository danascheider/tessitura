// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function() {
  $("input[type='checkbox']").click(function() {
    $(this).parents("tr").fadeOut();
  })
});
