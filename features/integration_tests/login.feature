@integration

Feature: User login

  Users need to be logged in to access any part of the site
  other than the homepage.

  Scenario:
    Given I am not logged in
    When I navigate to '/#login'
    And I submit the login form
    Then I should be redirected to my dashboard