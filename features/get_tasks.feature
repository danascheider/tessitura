Feature: Get tasks

  In order to know what I need to do today
  As an android
  I need to see my tasks in JSON format.

  Background:
    Given there are the following tasks:
      |id | title              | complete |
      | 1 | Take out the trash | false    |
      | 2 | Walk the dog       | false    |
      | 3 | Chunky bacon       | true     |
 
  Scenario: Get all task information
    When the client submits a GET request to /tasks
    Then the JSON response should include all the tasks

  Scenario: Get information about a specific task
    When the client submits a GET request to /tasks/1
    Then the JSON response should include only the 1st task

  Scenario: Get information about incomplete tasks only
    When the client submits a GET request to /tasks?complete=false
    Then the JSON response should not include the 3rd task

  Scenario: Try to get information about a task that doesn't exist
    When the client submits a GET request to /tasks/10
    Then the response should indicate the task was not found
