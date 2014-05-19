Feature: Create To-Do Item

  In order to keep track of what I have to do
  As a user
  I'm creating a new item on my to-do list

  Background:
    Given I am a user
    When I navigate to my new to-do item page

  Scenario: Logged-in user creates to-do item

    When I submit the filled-out form
    Then I should see a message that the to-do item was created

  Scenario: User doesn't give title
    
    User tries to create a to-do item but leaves the title field blank

    When I submit the form with no title
    Then I should see a message that the title field is required

  Scenario: Non-required fields are missing

    User creates a to-do item, filling out only the title field

    When I submit the form with only a title
    Then I should see a message that the to-do item was created