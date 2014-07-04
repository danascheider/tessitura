Feature: Manage task list 
  As a user
  in order to place my tasks into my schedule appropriately
  I need to manage my task list

  Background:
    Given there are the following tasks:
      |id | title              | complete | index |
      | 1 | Take out the trash | false    | 1     |
      | 2 | Walk the dog       | false    | 2     |
      | 3 | Chunky bacon       | false    | 3     |
      | 4 | Plan schedule      | true     | 4     |

  Scenario: User creates a new task without specifying an index
    When the client submits a POST request to /tasks with:
    """
    { "title":"Call mom" }
    """
    Then a task called "Call mom" should be created with index 1
    And all the other tasks' indices should be increased by 1

  Scenario: User creates a new task and specifies an index for it
    When the client submits a POST request to /tasks with:
    """
    { "title":"Call mom", "index":3 }
    """
    Then the 3rd and 4th tasks' indices should be increased by 1
    And the 1st and 2nd tasks' indices should not be changed
    And a task called "Call mom" should be created with index 3

  Scenario: User marks a task complete without specifying a new index for it
    When the client submits a PUT request to /tasks/1 with:
      """json
      { "complete":true }
      """
    Then the 1st task's index should be changed to 4
    And the other tasks should be moved up on the list by 1

  Scenario: User marks a task complete and specifies a new index
    When the client submits a PUT request to /tasks/1 with:
    """json
    { "complete":true, "index":2 }
    """
    Then the 1st task's index should be changed to 2
    And the 2nd task's index should be changed to 1

  Scenario: User moves a task down on the list
    When the client submits a PUT request to /tasks/1 with:
      """json
      { "index":3 }
      """
    Then the 1st task's index should be changed to 3
    And the 2nd and 3rd tasks' indices should be decreased by 1

  Scenario: User moves a task up on the list
    When the client submits a PUT request to /tasks/3 with:
    """json
    { "index":2 }
    """
    Then the 2nd task's index should be changed to 3
    And the 3rd task's index should be changed to 2

  Scenario: User deletes a task
    When the client submits a DELETE request to /tasks/2
    Then the 3rd and 4th tasks' indices should be decreased by 1

  Scenario: User sets invalid index
    When the client submits a PUT request to /tasks/1 with:
      """json
      { "index":10 }
      """
    Then the tasks' indices should not be changed