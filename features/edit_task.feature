Feature: Edit task
  
  In order to change important details of my plans
  As a user
  I need to edit one of my tasks

  Background:
    Given there is a task called "Take out the trash"

  Scenario: User changes title of task

    FIX: This action should route to the show page. However, I haven't
    found a way to do this without making the mark_complete task also 
    route to the show page, and it's more important for that to stay
    on the index, so I'm kicking this one down the road - spent a week
    already and that's about 6 days too long

    Likewise, I am commenting out the step requiring a message be
    shown that the title was updated.

    And I am on its edit page
    When I change its title to "Walk the dog"
    Then I should be routed to the task's show page
    And the task's title should be changed to "Walk the dog"
    And I should see a message that the title was changed

  Scenario: User marks task complete from the to-do list
    And I'm viewing my to-do list
    When I click the button next to the "Take out the trash" task
    Then I should stay on the to-do list page
    And the task's 'complete' attribute should be true
    And the task should disappear from the list