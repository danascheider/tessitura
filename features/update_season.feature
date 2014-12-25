@seasons
Feature: Update a season

  Scenario: Admin updates a season
    When the client submits a PUT request to /seasons/1 with admin credentials and:
      """json
      {"start_date":"2015-05-08" }
      """
    Then the season's start_date should be 2015-05-08
    And the response should return status 200

  Scenario: Admin attempts to update a season with invalid attributes
    When the client submits a PUT request to /seasons/1 with admin credentials and:
      """json
      {"program_id":null}
      """
    Then the season should not be updated
    And the response should return status 422

  Scenario: Admin attempts to update a nonexistent season
    Given there is no season with ID 247
    When the client submits a PUT request to /seasons/247 with admin credentials and:
      """json
      {"start_date":"2015-05-08" }
      """
    Then the response should return status 404

  Scenario Outline: Unauthorized attempt to update a season
    When the client submits a PUT request to /seasons/1 with <type> credentials and:
      """json
      {"start_date":"2015-05-08"}
      """
    Then the season's start_date should not be 2015-05-08
    And the response should indicate the request was unauthorized

    Examples:
      | type |
      | user | 
      | no   |