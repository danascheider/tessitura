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

  Scenario: Task is moved lower in the list

  Scenario: Task is marked complete

  Scenario: Task is deleted