Feature: Interact with dashboard widgets
  
  In order to efficiently keep track of everything I Have going on,
  As an opera singer
  I need to interact with my tasks and other items via the widgets on 
  my dashboard.

  Background:
    Given there are 5 tasks
    And there is a task called "Take out the trash"
    And I'm viewing my dashboard

  Scenario: User marks task complete from the dashboard
    When I mark the "Take out the trash" task complete
    Then I should not be redirected
    And the task's 'complete' attribute should be true
    And the task should disappear from the list

  Scenario: User edits task from the dashboard
    Given the details of the "Take out the trash" task are visible
    When I click the 'Edit' link
    Then I should not be redirected
    And the edit form should appear right where the task details had been