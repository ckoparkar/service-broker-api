# cf-postgresql-broker
CF PostgreSQL broker provides PostgreSQL databases as a Cloud Foundry service. This uses Service Broker API v2.4.

## Usage

1. Install the `cf` command line tool.
2. Push this broker app in the desired org + space.
3. Register the broker with CF. ([API Documentation](http://docs.cloudfoundry.org/services/managing-service-brokers.html))
4. Give users access to the service. ([API Documentation](http://docs.cloudfoundry.org/services/access-control.html#enable-access))

## PostgreSQL Service

This broker only implements a subset of the [Services API](http://docs.cloudfoundry.org/services/api.html).

API | Result |
--- | :----- |
/v2/catalog | Advertises the service and its plans offered in CF marketplace. |
/v2/service_instances/id | Creates a database `d-id` and user `u-id`. |

## Configuration
The file `config/settings.yml` configures:

* Catalog of services and plans available to users.
* Basic auth credentials to be used by CF to authenticate with the broker.
* PostgreSQL credentials and connection details.
