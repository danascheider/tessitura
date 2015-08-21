@churches @organizations
Feature: Create church
  
  Church is a subclass of Organization.

  Scenario: Admin creates a valid church
    When the client submits a POST request to /churches with admin credentials and:
      """json
      {"name": "Immaculate Heart Catholic Church"}
      """
    Then a new church should be created
    And the new church should be called "Immaculate Heart Catholic Church"
    And the response should return status 201
    And the response body should include the new church's ID

  Scenario: Admin attempts to create an invalid church
    When the client submits a POST request to /churches with admin credentials and:
      """json
      {"postal_code":97009}
      """
    Then no new church should be created
    And the response should indicate the church was not created successfully