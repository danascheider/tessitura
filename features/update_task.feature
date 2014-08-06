@tasks
Feature: Update task

  In order to keep the most current information about my tasks & schedule
  I need to edit my tasks

  Scenario Outline: Authorized user updates task with valid attributes
    When the client submits a PUT request to /tasks/<task_id> with <type> credentials and:
      """json
      { "<attribute>":"<value>" }
      """
    Then the task's <attr> should be changed to <val>
    And the response should indicate the task was updated successfully

    Examples:
      | task_id | type           | attribute | value              | attr  | val                |
      | 9       | the 3rd user's | title     | Take out the trash | title | Take out the trash |
      | 9       | the 1st user's | title     | Feed the cat       | title | Feed the cat       |

  Scenario Outline: Unauthorized user attempts to update task
    When the client submits a PUT request to /tasks/3 with <type> credentials and:
      """json
      { "<attribute>":"<value>" }
      """
    Then the task's <attr> should not be changed to <val>
    And the response should indicate the request was unauthorized

    Examples:
      | type           | attribute | value                 | attr  | val                   |
      | the 3rd user's | title     | Feed the cat          | title | Feed the cat          |
      | no             | title     | Rescue Princess Peach | title | Rescue Princess Peach |

  Scenario Outline: Change task status
    Given the 1st user's 3rd task is complete
    When the client submits a PUT request to <url> with the 1st user's credentials and:
      """json
      { "status":"<value>" }
      """
    Then the task's status should be <val>
    And the task's position should be changed to <pos>
    And the response should indicate the task was updated successfully

    Examples:
      | url      | value       | val         | pos |
      | /tasks/1 | complete    | complete    | 3   |
      | /tasks/3 | in_progress | in_progress | 1   |

  Scenario: User attempts to update a task that doesn't exist
    When the client submits a PUT request to /tasks/1000000 with the 1st user's credentials and:
      """json
      { "status":"complete" }
      """
    Then the response should indicate the task was not found

  Scenario: Attempt to update task with invalid attributes
    When the client submits a PUT request to /tasks/1 with the 1st user's credentials and:
      """json
      { "title":null }
      """
    Then the task's title should not be changed
    And the response should indicate the task was not updated successfully