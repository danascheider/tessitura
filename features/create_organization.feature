@organizations
Feature: Create organization

  At this point in time, only admins are allowed to create organizations.
  This may change in the future so other registered users can create them
  as well.

  Scenario: Admin creates valid organization
    When the client submits a POST request to /organizations with admin credentials and:
      """json
      {"name":"Chicago Lyric Opera", "website":"http://lyricopera.org"}
      """
    Then a new organization should be created
    And the new organization should be called "Chicago Lyric Opera"
    And the response should return status 201
    And the response body should include the new organization's ID

  Scenario Outline: Admin attempts to create invalid organization
    When the client submits a POST request to /organizations with admin credentials and:
      """json
      {"name":"<name>","website":"<url>"}
      """
    Then no new organization should be created
    And the response should indicate the organization was not created successfully

    Examples:
      | name                | website               |
      | Chicago Lyric Opera | lyricopera.org        |
      | null                | http://lyricopera.org |

  Scenario: Regular user attempts to create organization
    When the client submits a POST request to /organizations with the 2nd user's credentials and:
      """json
      {"name":"Metropolitan Opera", "website":"http://www.metropolitanopera.org"}
      """
    Then no new organization should be created 
    And the response should return status 401

  Scenario: Unregistered user attempts to create organization
    When the client submits a POST request to /organizations with no credentials and:
      """json
      {"name":"New York City Opera", "website":"http://nyopera.com"}
      """
    Then no new organization should be created 
    And the response should return status 401