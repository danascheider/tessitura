@listings
Feature: Create audition listing
  
  Users, admins, and people working for various arts organizations 
  want to create listings to provide singers with recommendations and 
  to attract talent to their programs

  Scenario: Normal listing creation

    When the client submits a POST request to /listings with valid attributes
    Then a new listing should be created with the same attributes
    And the listing should be flagged for review