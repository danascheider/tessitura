@programs
Feature: Create a new program

  Only admins are allowed to create programs currently. This may change in the future.

  Scenario: Admin creates a new program
    When the client submits a POST request to /organizations/1/programs with admin credentials and:
      """json
      {"name":"Wagner Competition"}
      """
    Then a new program should be created
    And the new program's name should be "Wagner Competition"
    And the new program's organization_id should be 1
    And the JSON response should include the new program's data
    And the response should return status 201

  Scenario: Admin attempts to create a new program with invalid attributes
    When the client submits a POST request to /organizations/1/programs with admin credentials and:
      """json
      {"country":"Pakistan","region":"Waziristan"}
      """
    Then no new program should be created
    And the response should return status 422

  Scenario: User attempts to create a new program
    When the client submits a POST request to /organizations/1/programs with user credentials and:
      """json
      {"name":"Hello Kitty Competition for Dramatic Voices"}
      """
    Then no new program should be created
    And the response should not return any data
    And the response should indicate the request was unauthorized