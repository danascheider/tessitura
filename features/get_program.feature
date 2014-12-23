@programs
Feature: View program information

  In order to set near-term career goals,
  As an opera singer,
  I need to view program information (and I have to be logged in to do it).

  Scenario Outline: Authorized user views single program
    When the client submits a GET request to /programs/1 with <type> credentials
    Then the JSON response should include the program's profile information
    And the response should return status 200

    Examples:
      | type  |
      | user  |
      | admin |

  Scenario: Unauthorized user attempts to view single program
    When the client submits a GET request to /programs/1 with no credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

  Scenario Outline: Authorized user views all programs for one organization
    Given there are 3 organizations
    And each organization has 3 programs
    When the client submits a GET request to /organizations/1/programs with <type> credentials
    Then the JSON response should include all 1st organization's programs
    And the response should not include the other programs
    And the response should return status 200

    Examples:
      | type  |
      | user  |
      | admin |

  Scenario: Organization has no programs
    Given organization 2 has no programs
    When the client submits a GET request to /organizations/2/programs with user credentials
    Then the response should include an empty JSON object
    And the response should return status 200