@javascript @integration

Feature: User login

  Users need to be logged in to access any part of the site
  other than the homepage.

  Scenario:
    Given I am a registered user
    And I am not logged in
    When I visit the homepage and click the login link
    And I submit the login form
    Then I should be redirected to my dashboard
    And the page status should be 200