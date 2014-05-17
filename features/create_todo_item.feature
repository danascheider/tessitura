Feature: Create To-Do Item

  In order to keep track of what I have to do
  As a user
  I'm creating a new item on my to-do list

  Background:
    Given I am a user
    When I navigate to my new to-do item page
    And I submit the filled-out form

  Scenario: Logged-in user creates to-do item

    Then a to-do item should be created
    And I should see a message that the to-do item was created

  Scenario: User doesn't give title
    
    User tries to create a to-do item but leaves the title field blank

    But I have left the title field blank
    Then no to-do item should be created

  Scenario: Non-required fields are missing

    User creates a to-do item, filling out only the title field

    But I have only filled out the title
    Then a to-do item with that title should be created