Feature: User login

  In order to view or edit my profile or tasks,
  As a user,
  I need to log into Canto.

  Background:
    Given I am a user
    And I am not logged in

  Scenario: Logged-out user visits site
    When I navigate to the Canto homepage
    Then there should be a link to log in 
    And the link should take me to the login page

  Scenario: User logs in
    When I navigate to the login page
    And I enter my username and password
    Then I should see my dashboard