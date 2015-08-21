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

  Scenario: Regular user attempts to create church

    For the time being, regular users are not permitted to create churches. In the future, they
    will be allowed to create them, but the churches they create will be subject to review prior
    to being added to the database.

    When the client submits a POST request to /churches with the 2nd user's credentials and:
      """json
      {"name":"Immaculate Heart Catholic Church"}
      """
    Then no new church should be created
    And the response should return status 401

  Scenario: Unregistered user attempts to create church

    Eventually, unregistered users may be permitted to create churches, subject to review.

    When the client submits a POST request to /churches with no credentials and:
      """json
      {"name":"Immaculate Heart Catholic Church"}
      """
    Then no new church should be created
    And the response should return status 401