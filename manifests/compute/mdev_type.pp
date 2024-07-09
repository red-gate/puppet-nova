# Define nova::compute::mdev_type
#
# Configures nova compute mdev_<type> options
#
# === Parameters:
#
# [*mdev_type*]
#  (Optional) mdev type
#  Defaults to $name
#
# [*device_addresses*]
#  (Optional) A list of PCI addresses corresponding to the physical GPU(s) or
#  mdev-capable hardware.
#  Defaults to $facts['os_service_default']
#
# [*mdev_class*]
#  (Optional) Class of mediated device to manage used to differentiate between
#  device type.
#  Defaults to $facts['os_service_default']
#
# [*max_instances*]
#  (Optional) Number of mediated devices that type can create.
#  Defaults to $facts['os_service_default']
#
define nova::compute::mdev_type (
  $mdev_type        = $name,
  $device_addresses = $facts['os_service_default'],
  $mdev_class       = $facts['os_service_default'],
  $max_instances    = $facts['os_service_default'],
) {

  nova_config {
    "mdev_${mdev_type}/device_addresses": value => join(any2array($device_addresses), ',');
    "mdev_${mdev_type}/mdev_class":       value => $mdev_class;
    "mdev_${mdev_type}/max_instances":    value => $max_instances;
  }
}
