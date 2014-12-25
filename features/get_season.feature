@seasons
Feature: View single season
  
  As an opera singer, in order to prepare my materials on time and plan my 
  finances effectively, I need to view season information for the programs
  I am interested in.

  Scenario: Logged-in user views single season
    When the client submits a GET request to /seasons/1 with user authorization
    Then the JSON response should include the 1st season's data
    And the response should return status 200

  Scenario: Attempt to view nonexistent season
    Given there is no season with ID 37
    When the client submits a GET request to /seasons/37 with user authorization
    Then the response should not include any data
    And the response should return status 404

  Scenario: Unauthorized user attempts to view single season
    When the client submits a GET request to /seasons/1 with no authorization
    Then the response should not include any data
    And the response should indicate the request was unauthorized