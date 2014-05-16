Feature: Create To-Do Item

  Scenario: Logged-in user creates to-do item

    As a user, I need to create a to-do item for myself so that I can keep track
    of what I need to do.

    Given I am logged in
    When I navigate to the new to-do item page
    And I submit the filled-out form
    Then a to-do item should be created
    And I should see a message that the to-do item was created

  Scenario: User doesn't give title
    
    A user tries to create a to-do item but leaves the title field blank

    Given I am logged in
    When I navigate to the new to-do item page
    And I submit the filled-out form
    But I have left the title field blank
    Then no to-do item should be created

  Scenario: Non-required fields are missing

    A user creates a to-do item, filling out only the title field

    Given I am logged in
    When I navigate to the new to-do item page
    And I submit the filled out form
    But I have only filled out the title
    Then a to-do item with that title should be created