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

    Completed tasks are moved lower on the list than incomplete ones. When 
    a task is marked complete, it goes on the list directly below the last
    incomplete task.

    When the task in position 6 on the 3rd user's list is marked complete
    Then its position should be changed to 10
    And the positions of tasks 10, 9, 8, and 7 should be 6, 7, 8, and 9
    And the positions of tasks 12, 13, 14, 15, and 16 should not be changed

  Scenario: Task is marked complete with other tasks also complete

    If a task is marked complete, it should go below the last incomplete task,
    even if there are complete tasks with higher positions (i.e., complete 
    tasks to which the user purposefully assigned a different position)

    Given tasks with the following attributes:
      | id | status   | position |
      | 7  | Complete | 3        |
      | 8  | Complete | 10       |
      | 9  | Complete | 9        |
    When the task in position 5 on the 3rd user's list is marked complete
    Then its position should be changed to 8
    And the positions of tasks 12, 11, and 10 should be 5, 6, and 7
    And the positions of tasks 16, 15, 7, 14, 8, and 9 should not be changed

  Scenario: Task is marked complete with a position specified

    If a task is marked complete and a position is specified for it, it 
    should honor the position being passed instead of going with the
    default behavior.

    Given tasks with the following attributes:
      | id | status   | position |
      | 7  | Complete | 3        |
      | 8  | Complete | 10       |
      | 9  | Complete | 9        |
    When the task in position 5 on the 3rd user's list is updated with:
      | status   | position |
      | Complete | 2        |
    Then its position should be changed to 2