# == Class: nova::compute::libvirt::libvirtd
#
# libvirtd configuration
#
# === Parameters:
#
# [*log_level*]
#   Defines a log level to filter log outputs.
#   Defaults to $::os_service_default
#
# [*log_filters*]
#   Defines a log filter to select a different logging level for
#   for a given category log outputs.
#   Defaults to $::os_service_default
#
# [*log_outputs*]
#   (optional) Defines log outputs, as specified in
#   https://libvirt.org/logging.html
#   Defaults to $::os_service_default
#
# [*max_clients*]
#   The maximum number of concurrent client connections to allow
#   on primary socket.
#   Defaults to $::os_service_default
#
# [*admin_max_clients*]
#   The maximum number of concurrent client connections to allow
#   on administrative socket.
#   Defaults to $::os_service_default
#
# [*tls_priority*]
#   (optional) Override the compile time default TLS priority string. The
#   default is usually "NORMAL" unless overridden at build time.
#   Only set this if it is desired for libvirt to deviate from
#   the global default settings.
#   Defaults to $::os_service_default
#
# [*ovs_timeout*]
#   (optional) A timeout for openvswitch calls made by libvirt
#   Defaults to $::os_service_default
#
class nova::compute::libvirt::libvirtd (
  $log_level         = $::os_service_default,
  $log_filters       = $::os_service_default,
  $log_outputs       = $::os_service_default,
  $max_clients       = $::os_service_default,
  $admin_max_clients = $::os_service_default,
  $tls_priority      = $::os_service_default,
  $ovs_timeout       = $::os_service_default,
) {

  include nova::deps

  $log_outputs_real = pick($::nova::compute::libvirt::log_outputs, $log_outputs)
  $log_filters_real = pick($::nova::compute::libvirt::log_filters, $log_filters)
  $tls_priority_real = pick($::nova::compute::libvirt::tls_prority, $tls_priority)
  $ovs_timeout_real = pick($::nova::compute::libvirt::ovs_timeout, $ovs_timeout)

  libvirtd_config {
    'log_level':         value => $log_level;
    'log_filters':       value => $log_filters_real, quote => true;
    'log_outputs':       value => $log_outputs_real, quote => true;
    'max_clients':       value => $max_clients;
    'admin_max_clients': value => $admin_max_clients;
    'tls_priority':      value => $tls_priority_real, quote => true;
    'ovs_timeout':       value => $ovs_timeout_real;
  }
}
