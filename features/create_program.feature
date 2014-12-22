@programs
Feature: Create a new program

  Only admins are allowed to create programs currently. This may change in the future.

  Scenario: Admin creates a new program
    When the client submits a POST request to /organizations/1/programs with admin credentials and:
      """json
      {"name":"Wagner Competition"}
      """
    Then a new program should be created
    And the program's name should be "Wagner Competition"
    And the program's organization_id should be 1