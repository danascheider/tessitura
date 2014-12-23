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

  Scenario: Attempt to view nonexistent program
    Given program 871 doesn't exist
    When the client submits a GET request to /programs/871 with admin credentials
    Then the response should not include any data
    Then the response should return status 404

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

  Scenario Outline: Unauthorized user attempts to view organization's programs
    Given there are 3 organizations
    And each organization has 3 programs
    When the client submits a GET request to /organizations/1/programs with <type> credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

    Examples:
      | type     |
      | invalid  |
      | no       |

  Scenario: Organization has no programs
    Given organization 2 has no programs
    When the client submits a GET request to /organizations/2/programs with user credentials
    Then the response should include an empty JSON object
    And the response should return status 200

  Scenario Outline: Authorized user views all programs
    Given there are 3 organizations
    And each organization has 3 programs
    When the client submits a GET request to /programs with <type> credentials
    Then the JSON response should include all the programs
    And the response should return status 200

    Examples:
      | type  |
      | user  | 
      | admin |

  Scenario Outline: Unauthorized user attempts to view all programs
    Given there are 3 organizations
    And each organization has 3 programs
    When the client submits a GET request to /programs with <type> credentials
    Then the response should not include any data
    And the response should indicate the request was unauthorized

    Examples: 
      | type    |
      | invalid |
      | no      |

  Scenario: There are no programs
    Given there are no programs
    When the client submits a GET request to /programs with admin credentials
    Then the response should include an empty JSON object
    And the response should return status 200
