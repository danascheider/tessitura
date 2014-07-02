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

  Scenario: User re-orders existing tasks
    When the client submits a PUT request to /tasks/1 with:
      """
      { 'index':3 }
      """
    Then the 1st task's index should be changed to 3
    And the 2nd task's index should be changed to 1
    And the 3rd task's index should be changed to 2

  Scenario: User marks a task complete
    When the client submits a PUT request to /tasks/1 with:
      """
      { 'complete':true }
      """
    Then the 1st task's index should be changed to 4
    And the other tasks should be moved up on the list by 1

  Scenario: User deletes a task
    When the client submits a DELETE request to /tasks/1
    Then the other tasks should be moved up on the list by 1

  Scenario: User creates a task with a certain index
    When the client submits a POST request to /tasks with:
      """
      { 'title':'Call mom', 'index':3 }
      """
    Then the tasks with indices 3 and 4 should move down the list by 1
    And the indices of the 1st and 2nd tasks should not change

  Scenario: User sets invalid index
    When the client submits a PUT request to /tasks/1 with:
      """
      { 'index':10 }
      """
    Then the tasks' indices should not be changed