@javascript @integration
Feature: User navigates to Canto

  Users navigating to the Canto main page are treated differently based on whether
  they are logged in.

  Scenario: User is not logged in
    Given I am not logged in 
    When I navigate to the Canto mainpage
    Then I should see the homepage
    And there should be a link where I can log in