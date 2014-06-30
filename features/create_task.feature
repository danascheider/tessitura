Feature: Create task
  In order to stay on top of my tasks
  As a user
  I need to create a new task

  Scenario: Create a valid task
    When the client submits a POST request to /tasks with "'title':'Water the plants'"
    Then a new task should be created with the title 'Water the plants'
    And the response should indicate the task was saved successfully