@seasons
Feature: Create season

  Only admins are allowed to mess with seasons.

  Scenario: Admin creates season
    When the client submits a POST request to /programs/1/seasons with admin credentials and:
      """json
      {"start_date":"2015-06-17"}
      """
    Then a new season should be created with the following attributes:
      | start_date | program_id |
      | 2015-06-17 | 1          |

  Scenario: Admin attempts to assign invalid program ID
    Given there is a program with ID 2
    When the client submits a POST request to /programs/1/seasons with admin credentials and:
      """json
      {"program_id":2}
      """
    Then a new season should be created with the following attributes:
      | program_id |
      | 1          |

  Scenario Outline: Unauthorized user attempts to create a season
    When the client submits a POST request to /programs/1/seasons with <type> credentials and:
      """json
      {"start_date":"2015-06-17"}
      """
    Then no new season should be created
    And the response should indicate the request was unauthorized

    Examples:
      | type |
      | user | 
      | no   |