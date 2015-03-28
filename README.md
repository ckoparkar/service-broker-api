# service-broker-api [![Build Status](https://travis-ci.org/cskksc/service-broker-api.svg)](https://travis-ci.org/cskksc/service-broker-api) [![Code Climate](https://codeclimate.com/github/cskksc/service-broker-api/badges/gpa.svg)](https://codeclimate.com/github/cskksc/service-broker-api) [![Test Coverage](https://codeclimate.com/github/cskksc/service-broker-api/badges/coverage.svg)](https://codeclimate.com/github/cskksc/service-broker-api)
A generic interface to implement any CF service broker. This uses Service Broker API v2.4.

## Usage
This sinatra app provides a generic api implementing the following requests:

API | Result |
--- | :----- |
GET /v2/catalog | Advertises the service and its plans offered in CF marketplace. |
PUT /v2/service_instances/:id | Creates a service instance named `d-id`. |
PUT /v2/service_instances/:instance_id/service_bindings/:binding_id | Creates a binding named `u-binding_id` on service instance `d-instance_id`.
DELETE /v2/service_instances/:instance_id/service_bindings/:binding_id | Deletes the binding `u-binding_id`.
DELETE /v2/service_instances/:instance_id | Deletes the service instance `d-instance_id`.

This interface can be extended by the user, depending upon the implementation specifics of the broker.

This requires sub-classing `ServiceBrokerApi` class and implementing the following methods.
* `create_instance(instance_name)`
* `bind_instance(binding_name, instance_name)`
* `delete_binding(binding_name)`
* `delete_binding(binding_name)`
* `delete_instance(instance_name)`

As an example, a broker for PostgreSQL is implemented in `lib/postgresql_broker`.

## Configuration
To get the broker working:
* Configure `config.ru` file.

## Development
Currently the tests are tied to postgresql specifics.
- [ ] Make the tests independent of broker implementation.

The broker is tested using cucumber features.
To run the tests continuously:
```
watchr watch-tests.watchr
```
