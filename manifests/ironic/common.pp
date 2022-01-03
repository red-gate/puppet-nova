# == Class: nova::ironic::common
#
# [*auth_plugin*]
#   The authentication plugin to use when connecting to nova.
#   Defaults to 'password'
#
# [*auth_url*]
#   The address of the Keystone api endpoint.
#   Defaults to 'http://127.0.0.1:5000/'
#
# [*project_name*]
#   The Ironic Keystone project name.
#   Defaults to 'services'
#
# [*password*]
#   The admin password for Ironic to connect to Nova.
#   Defaults to 'ironic'
#
# [*username*]
#   The admin username for Ironic to connect to Nova.
#   Defaults to 'admin'
#
# [*endpoint_override*]
#   (optional) Override the endpoint to use to talk to Ironic.
#   Defaults to $::os_service_default
#
# [*region_name*]
#   (optional) Region name for connecting to ironic in admin context
#   through the OpenStack Identity service.
#
# [*api_max_retries*]
#   Max times for ironic driver to poll ironic api
#
# [*api_retry_interval*]
#   Interval in second for ironic driver to poll ironic api
#
# [*user_domain_name*]
#   (Optional) Name of domain for $user_domain_name
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (Optional) Name of domain for $project_domain_name
#   Defaults to 'Default'
#
# [*service_type*]
#   (optional) The default service_type for endpoint URL discovery.
#   Defaults to $::os_service_default
#
# [*valid_interfaces*]
#   (Optional) The endpoint type to lookup when talking to Ironic.
#   Defaults to $::os_service_default
#
# [*timeout*]
#   (Optional) Timeout value for connecting to ironic in seconds.
#   Defaults to $::os_service_default
#
class nova::ironic::common (
  $auth_plugin          = 'password',
  $auth_url             = 'http://127.0.0.1:5000/',
  $password             = 'ironic',
  $project_name         = 'services',
  $username             = 'admin',
  $endpoint_override    = $::os_service_default,
  $region_name          = $::os_service_default,
  $api_max_retries      = $::os_service_default,
  $api_retry_interval   = $::os_service_default,
  $user_domain_name     = 'Default',
  $project_domain_name  = 'Default',
  $service_type         = $::os_service_default,
  $valid_interfaces     = $::os_service_default,
  $timeout              = $::os_service_default,
) {

  include nova::deps

  nova_config {
    'ironic/auth_plugin':         value => $auth_plugin;
    'ironic/username':            value => $username;
    'ironic/password':            value => $password, secret => true;
    'ironic/auth_url':            value => $auth_url;
    'ironic/project_name':        value => $project_name;
    'ironic/endpoint_override':   value => $endpoint_override;
    'ironic/region_name':         value => $region_name;
    'ironic/api_max_retries':     value => $api_max_retries;
    'ironic/api_retry_interval':  value => $api_retry_interval;
    'ironic/user_domain_name':    value => $user_domain_name;
    'ironic/project_domain_name': value => $project_domain_name;
    'ironic/service_type':        value => $service_type;
    'ironic/valid_interfaces':    value => join(any2array($valid_interfaces), ',');
    'ironic/timeout':             value => $timeout;
  }

}
