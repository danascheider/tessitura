Feature: Edit task
  
  In order to change important details of my plans
  As a user
  I need to edit one of my tasks

  Background:
    Given there is a task called "Take out the trash"

  Scenario: User changes title of task

    And I am on its edit page
    When I change its title to "Walk the dog"
    Then I should be routed to the task's show page
    And the task's title should be changed to "Walk the dog"
    And I should see a message that the title was changed

  Scenario: User marks task complete from the dashboard
    And I'm viewing my to-do list
    When I click the button next to the "Take out the trash" task
    Then I should stay on the to-do list page
    And the task's 'complete' attribute should be true
    And the task should disappear from the list