Feature: View dashboard
  
  In order to get a summary of my tasks and schedule
  As an opera singer
  I want to view the dashboard

  Scenario: Dashboard displays tasks
    Given there are 5 tasks
    When I navigate to the dashboard
    Then I should see a list of all the tasks