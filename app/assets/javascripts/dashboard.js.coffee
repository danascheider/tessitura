# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$(document).ready ->

  # Hide task details and show edit form when edit link clicked
  $('.ajax-edit-link').click (e) ->
    e.preventDefault()
    parentDiv = $(this).closest('.task-info')
    parentDiv.css('display', 'none')
    parentDiv.next().css('display', 'block')

  $('.edit-form input[type="submit"]').click (e) ->
    e.stopPropagation
    editFormDiv = $(this).closest('div.edit-form')
    taskInfoDiv = editFormDiv.prev()
    detailsDiv  = taskInfoDiv.children('div.task-details')
    editFormDiv.slideUp()
    taskInfoDiv.show()