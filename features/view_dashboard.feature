Feature: View dashboard
  
  In order to get a summary of my tasks and schedule
  As an opera singer
  I want to view the dashboard

  Background:
    Given there are 5 tasks
    When I navigate to the dashboard

  Scenario: Dashboard displays tasks
    Then I should see a list of all the tasks

  Scenario: User marks task complete from the dashboard
    When I click the button next to the "Take out the trash" task
    Then I should not be redirected
    And the task's 'complete' attribute should be true
    And the task should disappear from the list