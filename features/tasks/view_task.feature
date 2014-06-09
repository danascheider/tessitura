Feature: Show task
  In order to see the details of one of my tasks
  As a user
  I need to view the full listing for that item.

  Background:
    Given there are 4 tasks
    And the tasks are incomplete

  Scenario: User selects a task from the to-do list
    Given I'm viewing my to-do list
    When I click a task's title
    Then I should not be redirected
    And I should see the task's details