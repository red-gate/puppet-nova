# == Class: nova::compute::libvirt::config
#
# This class is used to manage arbitrary libvirtd configurations.
#
# === Parameters
#
# [*libvirtd_config*]
#   (optional) Allow configuration of arbitrary libvirtd configurations.
#   The value is an hash of libvirtd_config resources. Example:
#   { 'foo' => { value => 'fooValue'},
#     'bar' => { value => 'barValue'}
#   }
#   In yaml format, Example:
#   libvirtd_config:
#     foo:
#       value: fooValue
#     bar:
#       value: barValue
#
# [*virtlogd_config*]
#   (optional) Allow configuration of arbitrary virtlogd configurations.
#   The value is an hash of virtlogd_config resources.
#
# [*virtlockd_config*]
#   (optional) Allow configuration of arbitrary virtlockd configurations.
#   The value is an hash of virtlockd_config resources.
#
# [*virtnodedevd_config*]
#   (optional) Allow configuration of arbitrary virtnodedevd configurations.
#   The value is an hash of virtnodedevd_config resources.
#
# [*virtproxyd_config*]
#   (optional) Allow configuration of arbitrary virtproxyd configurations.
#   The value is an hash of virtproxyd_config resources.
#
# [*virtqemud_config*]
#   (optional) Allow configuration of arbitrary virtqemud configurations.
#   The value is an hash of virtqemud_config resources.
#
# [*virtsecretd_config*]
#   (optional) Allow configuration of arbitrary virtsecretd configurations.
#   The value is an hash of virtsecretd_config resources.
#
# [*virtstoraged_config*]
#   (optional) Allow configuration of arbitrary virtstoraged configurations.
#   The value is an hash of virtstoraged_config resources.
#
# [*qemu_config*]
#   (optional) Allow configuration of arbitrary qemu configurations.
#   The value is an hash of qemu_config resources.
#
#   NOTE: The configuration MUST NOT be already handled by this module
#   or Puppet catalog compilation will fail with duplicate resources.
#
class nova::compute::libvirt::config (
  Hash $libvirtd_config     = {},
  Hash $virtlogd_config     = {},
  Hash $virtlockd_config    = {},
  Hash $virtnodedevd_config = {},
  Hash $virtproxyd_config   = {},
  Hash $virtqemud_config    = {},
  Hash $virtsecretd_config  = {},
  Hash $virtstoraged_config = {},
  Hash $qemu_config         = {},
) {

  include nova::deps

  create_resources('libvirtd_config', $libvirtd_config)
  create_resources('virtlogd_config', $virtlogd_config)
  create_resources('virtlockd_config', $virtlockd_config)
  create_resources('virtnodedevd_config', $virtnodedevd_config)
  create_resources('virtproxyd_config', $virtproxyd_config)
  create_resources('virtqemud_config', $virtqemud_config)
  create_resources('virtsecretd_config', $virtsecretd_config)
  create_resources('virtstoraged_config', $virtstoraged_config)
  create_resources('qemu_config', $qemu_config)
}
