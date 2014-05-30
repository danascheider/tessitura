Feature: View to-do list 
  In order to remind myself what I need to get done
  As a user
  I need to see my list of tasks

  Scenario: To-do list is empty
    Given there are no tasks
    When I navigate to the to-do list
    Then I should not see any tasks
    And I should see a message stating I have no tasks
    And I should see a link to create a new task

  Scenario: There are tasks on the to-do list
    Given there are 3 tasks
    When I navigate to the to-do list
    Then I should see a list of all the tasks