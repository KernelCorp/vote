Feature: Organization's office
  As a organization
  I want see my office and I want to create voting!

  Scenario: Visit office page
    Given I sign in as organization name: "Сибирская корона"
    When  I go to "/organization/#{my_id}"
    Then  I should see text "Сибирская корона"
    And   I should see link "Настройки аккаунта"
    And   I should see table with votings
    And   I should see button "Одобрить выбранное"
    And   I should see button "Удалить выбранное"
    And   I should see button "Создать голосование"

  @javascript
  Scenario: Show settings
    Given I sign in as organization name: "Сибирская корона"
    When  I go to "/organization/#{my_id}"
    And   I click to link 'Настройки аккаунта'
    Then  I should see form: "organization edit"

  @javascript
  Scenario: New voting
    Given I sign in as organization name: "Сибирская корона"
    When  I go to "/organization/#{my_id}"
    And   I click to button "Создать новое голосование"
    And   I fill required inputs on page
    And   I click to button 'Сохранить и отправить на проверку'
    Then  I should redirect "/organization/#{my_id}"
    And   I should see 1 voting with status "На подтверждении"




