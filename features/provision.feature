Feature: As a user I can provision service instances

  Scenario: I can create a new service instance
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"

  Scenario: I try to create a duplicate service instance
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    When I create a service instance with :instance_id "1"
    Then the response status should be "409"

  Scenario: Consequtive provisioning requests
    When I create a service instance with :instance_id "1"
    Then the response status should be "201"
    When I create a service instance with :instance_id "2"
    Then the response status should be "201"

  Scenario: PostgreSQL server is not reachable
    When the server is not reachable
    When I create a service instance with :instance_id "1"
    Then the response status should be "500"
