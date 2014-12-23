@programs
Feature: Update program
  
  Programs can only be updated by admins.

  Scenario: Admin updates program with valid attributes
    When the client submits a PUT request to /programs/1 with admin credentials and:
      """json
      {"max_age":28}
      """
    Then the program's max_age should be 28
    And the response should return status 200

  Scenario: Admin tries to update program with invalid attributes
    When the client submits a PUT request to /programs/1 with admin credentials and:
      """json
      {"foo":"bar"}
      """
    Then the program should not be changed
    And the response should indicate the program was not saved successfully

  Scenario: Admin tries to update nonexistent program
    Given program 47 doesn't exist
    When the client submits a PUT request to /programs/47 with admin credentials and:
      """json
      {"max_age":28}
      """
    Then the response should not include any data
    And the response should return status 404

  Scenario Outline: Non-admin tries to update program
    When the client submits a PUT request to /programs/1 with <type> credentials and:
      """json
      {"max_age":28}
      """
    Then the program should not be changed
    And the response should indicate the request was unauthorized

    Examples:
      | type |
      | user |
      | no   |