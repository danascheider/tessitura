@javascript @integration
Feature: User navigates to Canto

  Users navigating to the Canto main page are treated differently based on whether
  they are logged in.

  Scenario: User is not logged in
    Given I am not logged in 
    When I navigate to the Canto mainpage
    Then I should see the homepage
    And there should be a link where I can log in

  Scenario: User is logged in 
    Given I am a registered user
    And I am logged in
    When I navigate to the Canto mainpage
    Then I should be redirected to my dashboard

  Scenario: Logged-in user navigates to /#home
    Given I am a registered user
    Given I am logged in 
    When I navigate to '/#home'
    Then I should see the homepage
    And I should not be redirected to my dashboard