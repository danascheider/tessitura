@programs
Feature: Delete program
  
  Programs can only be deleted from the system by an admin

  Scenario: Admin deletes program
    When the client submits a DELETE request to /programs/1 with admin credentials
    Then the program should be deleted
    And the response should indicate the program was deleted successfully

  Scenario: Admin attempts to delete nonexistent program
    Given program 238 doesn't exist
    When the client submits a DELETE request to /programs/238 with admin credentials
    Then program 1 should not be deleted
    And the response should return status 404

  Scenario: Unauthorized user attempts to delete program
    When the client submits a DELETE request to /programs/1 with no credentials
    Then program 1 should not be deleted
    And the response should indicate the request was unauthorized