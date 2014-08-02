Feature: Get tasks

  In order to know what I need to do today
  As an android
  I need to see my tasks in JSON format.

  Background:
    Given there is a user with 3 tasks
    And the 3rd task is complete

  Scenario Outline: Get task information
    When the client submits a GET request to <path>
    Then the JSON response should include <contents>

    Examples:
      | path                  | contents                  |
      | /tasks                | all the tasks             |
      | /tasks/1              | only the 1st task         |

  Scenario: Try to get information about a task that doesn't exist
    When the client submits a GET request to /tasks/10
    Then the response should indicate the task was not found
