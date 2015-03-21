Feature: As a user I can provision service instances

  Scenario: I can create a new service instance
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    Then the response status should be "201"

  Scenario: I try to create a duplicate service instance
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    Then the response status should be "201"
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    Then the response status should be "409"

  Scenario: Consequtive provisioning requests
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    Then the response status should be "201"
    When I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 2 |
    Then the response status should be "201"

  Scenario: PostgreSQL server is not reachable
    When the server is not reachable
    And I send PUT request to "/v2/service_instances/:id" with the following:
    | id | 1 |
    Then the response status should be "500"
