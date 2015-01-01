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

  Scenario: New task is created with status complete

    If a new task is created with status set to 'Complete', then it should be treated
    just like any other complete task.

    When the client submits a POST request to /users/3/tasks with the 3rd user's credentials and:
      """json
      {"title":"Buy deodorant","status":"Complete"}
      """
    Then the position of the new task should be 11

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

  Scenario: Task is backlogged

    Backlogged tasks are moved lower on the list than incomplete tasks, but
    above complete ones. When a task is backlogged, it goes on the list
    directly below the last non-backlogged task.

    When the task in position 6 on the 3rd user's list is backlogged
    Then its position should be changed to 10
    And the positions of tasks 10, 9, 8, and 7 should be 6, 7, 8, and 9
    And the positions of tasks 12, 13, 14, 15, and 16 should not be changed

  Scenario: Task is backlogged with other tasks also backlogged

    If a task is backlogged, it should go after the last incomplete,
    non-backlogged task, even if there are backlogged tasks with higher positions
    (i.e., backlogged tasks to which the user has purposefully assigned a
    different position).

    Given tasks with the following attributes:
      | id | backlog | position |
      | 7  | true    | 3        |
      | 8  | true    | 10       |
      | 9  | true    | 9        |
    When the task in position 5 on the 3rd user's list is backlogged
    Then its position should be changed to 8
    And the positions of tasks 12, 11, and 10 should be 5, 6, and 7
    And the positions of tasks 16, 15, 7, 14, 8, and 9 should not be changed

  Scenario: Task is backlogged with a position specified

    If a task is backlogged and a position is specified for it, it 
    should honor the position being passed instead of going with the
    default behavior.

    Given tasks with the following attributes:
      | id | backlog   | position |
      | 7  | true      | 3        |
      | 8  | true      | 10       |
      | 9  | true      | 9        |
    When the task in position 5 on the 3rd user's list is updated with:
      | backlog   | position |
      | true      | 2        |
    Then its position should be changed to 2

    # Because the tasks were modified in the Given step for this scenario,
    # their order was changed from that assigned in the hook. 15, 7, and 4
    # are the tasks that were in positions 2, 3, and 4 when the When step
    # was executed

    And the positions of tasks 15, 7, and 14 should be 3, 4, and 5
    And the positions of tasks 8, 9, 10, 11, 12, and 16 should not be changed

  Scenario: Backlogged task is marked complete

    Backlogged tasks are treated the same as other tasks when they are
    marked complete.

    Given tasks 7 and 8 are complete
    And tasks 9 and 10 are backlogged
    When task 10 is marked complete
    Then its position should be changed to 8
    And the position of task 9 should be 7

  Scenario: Task is backlogged when there are complete and backlogged tasks

    Incomplete, backlogged tasks should go between incomplete, non-backlogged
    tasks and complete tasks.

    Given tasks with the following attributes:
      | id | status   | backlog | position |
      | 7  | Complete | false   | 10       |
      | 8  | Complete | true    | 9        |
      | 9  | Complete | false   | 8        |
      | 10 | New      | true    | 7        |
      | 11 | New      | true    | 6        |
    When task 14 is backlogged
    Then its position should be changed to 5

  Scenario: Task is marked complete when there are complete and backlogged tasks

    Incomplete, backlogged tasks should go between incomplete, non-backlogged
    tasks and complete tasks.

    Given tasks with the following attributes:
      | id | status   | backlog | position |
      | 7  | Complete | false   | 10       |
      | 8  | Complete | true    | 9        |
      | 9  | Complete | false   | 8        |
      | 10 | New      | true    | 7        |
      | 11 | New      | true    | 6        |
    When task 14 is marked complete
    Then its position should be changed to 7

  Scenario: Complete task status is changed

    If a task is complete and its status is changed to something else, it should be
    moved to the top of the list.

    Given tasks 7 and 8 are complete
    When the client submits a PUT request to /tasks/7 with the 1st user's credentials and:
      """json
      {"status":"In Progress"}
      """
    Then the position of task 7 should be 1
    And the 3rd user's other tasks should have their positions incremented

  Scenario: Task removed from the backlog

    If an incomplete, backlogged task is removed from the backlog, its position should be
    changed to 1.

    Given tasks 7 and 8 are backlogged
    When the client submits a PUT request to /tasks/7 with the 1st user's credentials and:
      """json
      {"backlog":null}
      """
    Then the position of task 7 should be 1
    And the 3rd user's other tasks should have their positions incremented

  Scenario: Status changed when task is complete and backlogged
    Given tasks with the following attributes:
      | id | status   | backlog |
      | 7  | Complete | true    |
      | 8  | Complete | false   |
    When the client submits a PUT request to /tasks/7 with the 3rd user's credentials and:
      """json
      {"status":"New"}
      """
    Then the position of task 7 should be 9
    And the position of task 8 should be 10