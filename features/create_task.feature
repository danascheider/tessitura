@tasks
Feature: Create task
  In order to stay on top of my tasks
  As a user
  I need to create a new task

  Scenario Outline: Authorized user creates a valid task
    When the client submits a POST request to /users/2/tasks with the <id> user's credentials and:
      """json
      { "title":"Water the plants" }
      """
    Then a new task should be created on the 2nd user's task list
    And the new task should have the following attributes:
      | title            | status | priority |
      | Water the plants | new    | normal   |
    And the response should indicate the task was saved successfully

    Examples:
      | id  |
      | 2nd | 
      | 1st |

  Scenario Outline: Unauthorized user attempts to create a task
    When the client submits a POST request to /users/2/tasks with <type> credentials and:
      """json
      { "<attribute>":"<value>" }
      """
    Then no task should be created
    And the response should indicate <outcome>

    Examples: 
      | type           | attribute | value            | outcome                             |
      | the 3rd user's | title     | Water the plants | the request was unauthorized        |
      | no             | title     | Water the plants | the request was unauthorized        |
      | the 2nd user's | status    | blocking         | the task was not saved successfully |