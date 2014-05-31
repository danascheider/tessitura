Feature: Edit task
  
  In order to change important details of my plans
  As a user
  I need to edit one of my tasks

  Background:
    Given there is a task called "Take out the trash"
    And I am on its edit page

  Scenario: User changes title of task
    When I change its title to "Walk the dog"
    Then I should be routed to the task's show page
    And the task's title should be changed to "Walk the dog"
    And I should see a message that the title was changed