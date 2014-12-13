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

  Scenario: Task is moved higher in the list

    Moving a task with position n0 to position n1 should cause another task's
    positions to be incremented if that task's position p satisfies n1 <= p < n0.

    # Task 9 is currently in position 8
    When the client request to change the 9th task's position to 4
    Then the position of task 9 should be 4

    # Task 13 is the task currently in position 4
    And the positions of tasks 13, 12, 11, and 10 should be 5, 6, 7, and 8
    And the positions of tasks 7, 8, 14, 15, and 16 should not be changed

  Scenario: Task is moved lower in the list

  Scenario: Task is marked complete

  Scenario: Task is deleted