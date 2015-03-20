Feature: As a user I can access service catalog

  Scenario: I can get catlog
    When I GET on "/v2/catalog"
    Then I should see "services"
