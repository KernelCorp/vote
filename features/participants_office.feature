Feature: Participants Office
  As a participant
  I want see my office and I want vote! Give me to vote!

  Scenario: Visit office page
    Given   I sign in as participant
    And     I'm participant in 2 any voting
    When    I go to "/participant/#{my_id}"
    Then    I should see info panel
    And     I should see my balance
    And     I should see button "add balance"
    And     I should see 2 voting
    And     I should see 2 buttons 'vote'
    And     I see widget

  Scenario: Try to vote with sufficient balance
    Given   I sign in as participant
    And     I'm participant in 1 any voting
    And     I have balance more than need to vote
    When    I go to "/participant/#{my_id}"
    And     I click to button "vote"
    Then    I should see that my balance became less

  Scenario: Try to vote insufficient balance
    Given   I sign in as participant
    And     I'm participant in 1 any voting
    And     I have balance less than need to vote
    When    I go to "/participant/#{my_id}"
    And     I click to button "vote"
    Then    I should see label "need more gold"

  Scenario: Add balance
    Given   I sign in as participant
    When    I go to "/participant/#{my_id}"
    And     I fill "sum input"
    And     I click button "add balance"
    Then    I redirect to robokassa




