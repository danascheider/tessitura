@churches @organizations
Feature: Update church profile

  Currently, only admins can update church profiles. Later, ordinary users may
  be permitted to make changes pending admin approval.

  Scenario: Admin updates church
    When the client submits a PUT request to /churches/2 with admin credentials and:
      """json
      {"address_1":"1212 Elm St."}
      """
    Then the church's address_1 should be "1212 Elm St."
    And the response should indicate the church was updated successfully

  Scenario: Admin attempts to update church with invalid attributes
    When the client submits a PUT request to /churches/2 with admin credentials and:
      """json
      {"name":null}
      """
    Then the church's name should not be empty
    And the response should return status 422

  Scenario: Admin attempts to update nonexistent church
    When the client submits a PUT request to /churches/2851071531058 with admin credentials and:
      """json
      {"address_1":"1212 Elm St."}
      """
    Then the response should return status 404

  Scenario: User attempts to update church
    When the client submits a PUT request to /churches/2 with user credentials and:
      """json
      {"city":"Cedar Falls"}
      """
    Then the church's city should not be "Cedar Falls"
    And the response should indicate the request was unauthorized

  Scenario: User attempts to update church without logging in
    When the client submits a PUT request to /churches/2 with no credentials and:
      """json
      {"region":"WV"}
      """
    Then the church's region should not be "WV"
    And the response should indicate the request was unauthorized