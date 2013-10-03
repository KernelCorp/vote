Feature: Widget
  In order widget for registration phone voting. There must be a possibility to insert this widget to any site. All
  request by ajax, url should contained our domain.
  As a registered participants and guests
  I want to register thr phone in the voting, if user sign in participants, and render sign in and sing up form, else

  Scenario Sign in user registered:
    Given I sign in as participants
    When I go to "/test_widget_page"
    And I filled phone's input
    And I click to button 'submit'
    Then I should see response OK
    And My phone participates in the voting

  Scenario: Not sign in user
    Given I don't sign in
    When I go to "/test_widget_page"
    And I filled phone's input
    And I click to button 'submit'
    Then I should see sign in form

  Scenario: For user without account
    Given I don't sign in
    When I go to "/test_widget_page"
    And I filled phone's input
    And I click to button 'submit'
    Then I should see sign up form
    And I should see input for "email"
    And I should see input for "login"
    And I should see input for "password"
    And I should see input for "confirm password"