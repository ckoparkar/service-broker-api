Feature: As a user I can un-provision service instances

  Scenario: I can create a new service instance
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    And I un-provision a service instance with :instance_id "1"
    Then the response status should be "200"

  Scenario: I try to delete a non-existant service instance
    And I un-provision a service instance with :instance_id "1"
    Then the response status should be "410"

  Scenario: PostgreSQL server is not reachable
    When the server is not reachable
    When I create a service instance with :instance_id "1"
    Then the response status should be "500"
