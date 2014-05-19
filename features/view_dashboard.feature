Feature: View dashboard
  In order to get a quick summary of my tasks and obligations
  As a user
  I want to look at my dashboard

  Scenario: User logs in

    Given I am a user
    When I log in 
    I should see my dashboard