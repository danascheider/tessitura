Feature: User login

  In order to view or edit my profile or tasks,
  As a user,
  I need to log into Canto.

  Background:
    Given I am a user

  Scenario: Logged-out user visits site
    Given I am not logged in
    When I navigate to the Canto homepage
    Then there should be a link to log in 

  Scenario: User logs in
    Given I am not logged in
    When I navigate to the login page
    And I enter my username and password
    Then I should see my dashboard