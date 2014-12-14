@tasks @position
Feature: Update task position
  
  As a user,
  in order to stay on top of my most important tasks
  when I change the position of a task on my dashboard,
  I need the rest of my tasks to change their position as well

  Scenario: New task is created

    New tasks should appear at position 1 by default. Existing
    tasks have their position incremented when a new task is 
    created.

    When the client submits a POST request to /users/1/tasks with the 1st user's credentials and:
      """json
        {"title":"Get graduation card for Mike"}
      """
    Then the position of the new task should be 1
    And the 1st user's other tasks should have their positions incremented

  Scenario Outline: Task position is changed

    Moving a task with position n0 to position n1, where "n1 < n0", should cause 
    another task's position to be incremented if that position p satisfies "n1 <= p < n0".

    Moving a task with position n0 to position n1, where "n1 > n0", should cause
    another task's position to be decremented if that position p satisfies "n0 < p <= n1".

    When the client requests to change the <id>th task's position to <pos>
    Then the position of task <id> should be <pos>
    And the positions of tasks <changed> should be <positions>
    And the positions of tasks <unchanged> should not be changed

    Examples:
      | id | pos | changed            | positions      | unchanged            |
      | 9  |  4  | 13, 12, 11, and 10 | 5, 6, 7, and 8 | 7, 8, 14, 15, and 16 |
      | 13 |  8  | 12, 11, 10, and 9  | 4, 5, 6, and 7 | 7, 8, 14, 15, and 16 |

  Scenario: Task is deleted

    Deleting a task should decrement the positions of the tasks lower on the 
    list than the one that was deleted.

    When the client requests to delete task 10
    Then the positions of tasks 9, 8, and 7 should be 7, 8, and 9
    And the positions of tasks 11, 12, 13, 14, 15, and 16 should not be changed

  Scenario: Task is marked complete
