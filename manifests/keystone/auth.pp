# == Class: nova::keystone::auth
#
# Creates nova endpoints and service account in keystone
#
# === Parameters:
#
# [*password*]
#   (Required) Password to create for the service user
#
# [*auth_name*]
#   (Optional) The name of the nova service user
#   Defaults to 'nova'
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'nova'.
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'compute'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'OpenStack Compute Service'.
#
# [*public_url*]
#   (Optional) The endpoint's public url.
#   Defaults to 'http://127.0.0.1:8774/v2.1'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   Defaults to 'http://127.0.0.1:8774/v2.1'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   Defaults to 'http://127.0.0.1:8774/v2.1'
#
# [*region*]
#   (Optional) The region in which to place the endpoints
#   Defaults to 'RegionOne'
#
# [*tenant*]
#   (Optional) The tenant to use for the nova service user
#   Defaults to 'services'
#
# [*roles*]
#   (Optional) List of roles assigned to the nova service user
#   Defaults to ['admin']
#
# [*system_scope*]
#   Scope for system operations
#   string; optional: default to 'all'
#
# [*system_roles*]
#   List of system roles;
#   string; optional: default to []
#
# [*email*]
#   (Optional) The email address for the nova service user
#   Defaults to 'nova@localhost'
#
# [*configure_endpoint*]
#   (Optional) Whether to create the endpoint.
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Whether to create the service user.
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Whether to configure the admin role for the service user.
#   Defaults to true
#
class nova::keystone::auth(
  $password,
  $auth_name               = 'nova',
  $service_name            = 'nova',
  $service_type            = 'compute',
  $service_description     = 'OpenStack Compute Service',
  $region                  = 'RegionOne',
  $tenant                  = 'services',
  $roles                   = ['admin'],
  $system_scope            = 'all',
  $system_roles            = [],
  $email                   = 'nova@localhost',
  $public_url              = 'http://127.0.0.1:8774/v2.1',
  $internal_url            = 'http://127.0.0.1:8774/v2.1',
  $admin_url               = 'http://127.0.0.1:8774/v2.1',
  $configure_endpoint      = true,
  $configure_user          = true,
  $configure_user_role     = true,
) {

  include nova::deps

  Keystone::Resource::Service_identity['nova'] -> Anchor['nova::service::end']

  keystone::resource::service_identity { 'nova':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    service_name        => $service_name,
    region              => $region,
    auth_name           => $auth_name,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

}
