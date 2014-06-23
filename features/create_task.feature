Feature: Creating Tasks
  In order to remember what I have to get done,
  as a Canto user, 
  I need to create a task for my to-do list

  Background:
    Given there are 4 tasks
    And I am on the 'New Task' page

  Scenario: User creates a task
    When I submit the form with the title 'Take out the trash'
    Then a new task called 'Take out the trash' should be created

  Scenario: User leaves the title field blank
    When I submit the form blank
    Then no task should be created
    And I should see a message saying that title is required