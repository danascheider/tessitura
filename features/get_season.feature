@seasons
Feature: View seasons
  
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

  @bulk
  Scenario: Logged-in user views fresh seasons of a single program
    When the client submits a GET request to /programs/2/seasons with user authorization
    Then the JSON response should include the program's fresh seasons
    And the response should not include the program's stale seasons
    And the response should return status 200

  @bulk
  Scenario: Program has no fresh seasons
    Given program 3 has only stale seasons
    When the client submits a GET request to /programs/3/seasons with user authorization
    Then the response should include an empty JSON object
    And the response should return status 200

  @bulk
  Scenario: Unauthorized user attempts to view fresh seasons of a single program
    When the client submits a GET request to /programs/2/seasons with no authorization
    Then the response should not include any data
    And the response should indicate the request was unauthorized