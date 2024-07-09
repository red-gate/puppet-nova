# Class nova::pci
#
# Configures nova pci options
#
# === Parameters:
#
#  [*aliases*]
#   (optional) A list of pci alias hashes
#   Defaults to $facts['os_service_default']
#   Example:
#   [{"vendor_id" => "1234", "product_id" => "5678", "name" => "default"},
#    {"vendor_id" => "1234", "product_id" => "6789", "name" => "other"}]

class nova::pci(
  $aliases = $facts['os_service_default']
) {
  include nova::deps

  if !is_service_default($aliases) and !empty($aliases) {
    $aliases_real = to_array_of_json_strings($aliases)
  } else {
    $aliases_real = $facts['os_service_default']
  }
  nova_config {
    'pci/alias': value => $aliases_real;
  }
}
