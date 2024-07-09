# == Class: nova::migration::libvirt
#
# Sets libvirt config that is required for migration
#
# === Parameters:
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*transport*]
#   (optional) Transport to use for live-migration.
#   Valid options are 'tcp', 'tls', and 'ssh'.
#   Defaults to 'tcp'
#
# [*auth*]
#   (optional) Use this authentication scheme for remote libvirt connections.
#   Valid options are none and sasl.
#   Defaults to 'none'
#
# [*listen_address*]
#   (optional) Bind libvirtd tcp/tls socket to the given address.
#   Defaults to $facts['os_service_default'] (bind to all addresses)
#
# [*migration_inbound_addr*]
#   (optional) The address used as the migration address for this host.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_inbound_addr*]
#   (optional) The IP address or hostname to be used as the target for live
#   migration traffic.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_with_native_tls*]
#   (optional) This option will allow both migration stream (guest RAM plus
#   device state) *and* disk stream to be transported over native TLS, i.e.
#   TLS support built into QEMU.
#   Prerequisite: TLS environment is configured correctly on all relevant
#   Compute nodes.  This means, Certificate Authority (CA), server, client
#   certificates, their corresponding keys, and their file permissions are
#   in place, and are validated.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_bandwidth*]
#   (optional) Maximum bandwidth(in MiB/s) to be used during migration.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_downtime*]
#   (optional) Target maximum period of time Nova will try to keep the instance
#   paused during the last part of the memory copy, in miliseconds.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_downtime_steps*]
#   (optional) Number of incremental steps to reach max downtime value.
#   Minimum number of steps is 3.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_downtime_delay*]
#   (optional) Time to wait, in seconds, between each step increase of the migration
#   downtime. Value is per GiB of guest RAM + disk to be transferred, with lower bound
#   of a minimum of 2 GiB per device. Minimum delay is 3 seconds.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_completion_timeout*]
#   (optional) Time to wait, in seconds, for migration to successfully complete
#   transferring data before aborting the operation. Value is per GiB of guest
#   RAM + disk to be transferred, with lower bound of a minimum of 2 GiB. Set
#   to 0 to disable timeouts.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_timeout_action*]
#   (optional) This option will be used to determine what action will be taken
#   against a VM after live_migration_completion_timeout expires. By default,
#   the live migrate operation will be aborted after completion timeout.
#   If it is set to force_complete, the compute service will either pause the
#   VM or trigger post-copy depending on if post copy is enabled and available
#   Defaults to $facts['os_service_default']
#
# [*live_migration_permit_post_copy*]
#   (optional) This option allows nova to switch an on-going live migration
#   to post-copy mode, i.e., switch the active VM to the one on the destination
#   node before the migration is complete, therefore ensuring an upper bound
#   on the memory that needs to be transferred.
#   Post-copy requires libvirt>=1.3.3 and QEMU>=2.5.0.
#   Defaults to $facts['os_service_default']
#
# [*live_migration_permit_auto_converge*]
#   (optional) This option allows nova to start live migration with auto
#   converge on. Auto converge throttles down CPU if a progress of on-going
#   live migration is slow. Auto converge will only be used if this flag is
#   set to True and post copy is not permitted or post copy is unavailable
#   due to the version of libvirt and QEMU in use.
#   Defaults to $facts['os_service_default']
#
# [*override_uuid*]
#   (optional) Set uuid not equal to output from dmidecode (boolean)
#   Defaults to false
#
# [*host_uuid*]
#   (optional) Set host_uuid to this value, instead of generating a random
#   uuid, if override_uuid is set to true.
#   Defaults to undef
#
# [*configure_libvirt*]
#   (optional) Whether or not configure libvirt bits.
#   Defaults to true.
#
# [*configure_nova*]
#   (optional) Whether or not configure libvirt bits.
#   Defaults to true.
#
# [*client_user*]
#   (optional) Remote user to connect as.
#   Only applies to ssh transport.
#   Defaults to undef (root)
#
# [*client_port*]
#   (optional) Remote port to connect to.
#   Defaults to undef (default port for the transport)
#
# [*client_extraparams*]
#   (optional) Hash of additional params to append to the live-migration uri
#   See https://libvirt.org/guide/html/Application_Development_Guide-Architecture-Remote_URIs.html
#   Defaults to {}
#
# [*key_file*]
#   (optional) Specifies the key file that the TLS transport will use.
#   Note that this is only used if the TLS transport is enabled via the
#   "transport" option.
#   Defaults to $facts['os_service_default']
#
# [*cert_file*]
#   (optional) Specifies the certificate file that the TLS transport will use.
#   Note that this is only used if the TLS transport is enabled via the
#   "transport" option.
#   Defaults to $facts['os_service_default']
#
# [*ca_file*]
#   (optional) Specifies the CA certificate that the TLS transport will use.
#   Note that this is only used if the TLS transport is enabled via the
#   "transport" option.
#   Defaults to $facts['os_service_default']
#
# [*crl_file*]
#   (optional) Specifies the CRL file that the TLS transport will use.
#   Note that this is only used if the TLS transport is enabled via the
#   "transport" option.
#   Defaults to $facts['os_service_default']
#
# [*libvirt_version*]
#   (optional) installed libvirt version. Default is automatic detected depending
#   of the used OS installed via ::nova::compute::libvirt::version::default .
#   Defaults to ::nova::compute::libvirt::version::default
#
# [*modular_libvirt*]
#   (optional) Whether to enable modular libvirt daemons or use monolithic
#   libvirt daemon.
#   Defaults to undef
#
# DEPRECATED PARAMETERS
#
# [*live_migration_tunnelled*]
#   (optional) Whether to use tunnelled migration, where migration data is
#   transported over the libvirtd connection.
#   If True, we use the VIR_MIGRATE_TUNNELLED migration flag, avoiding the
#   need to configure the network to allow direct hypervisor to hypervisor
#   communication.
#   If False, use the native transport.
#   If not set, Nova will choose a sensible default based on, for example
#   the availability of native encryption support in the hypervisor.
#   Defaults to undef
#
class nova::migration::libvirt(
  Boolean $manage_service              = true,
  Enum['tcp', 'tls', 'ssh'] $transport = 'tcp',
  Enum['sasl', 'none'] $auth           = 'none',
  $listen_address                      = $facts['os_service_default'],
  $migration_inbound_addr              = $facts['os_service_default'],
  $live_migration_inbound_addr         = $facts['os_service_default'],
  $live_migration_with_native_tls      = $facts['os_service_default'],
  $live_migration_bandwidth            = $facts['os_service_default'],
  $live_migration_downtime             = $facts['os_service_default'],
  $live_migration_downtime_steps       = $facts['os_service_default'],
  $live_migration_downtime_delay       = $facts['os_service_default'],
  $live_migration_completion_timeout   = $facts['os_service_default'],
  $live_migration_timeout_action       = $facts['os_service_default'],
  $live_migration_permit_post_copy     = $facts['os_service_default'],
  $live_migration_permit_auto_converge = $facts['os_service_default'],
  Boolean $override_uuid               = false,
  $host_uuid                           = undef,
  Boolean $configure_libvirt           = true,
  Boolean $configure_nova              = true,
  $client_user                         = undef,
  $client_port                         = undef,
  Hash $client_extraparams             = {},
  $key_file                            = $facts['os_service_default'],
  $cert_file                           = $facts['os_service_default'],
  $ca_file                             = $facts['os_service_default'],
  $crl_file                            = $facts['os_service_default'],
  $libvirt_version                     = $::nova::compute::libvirt::version::default,
  Optional[Boolean] $modular_libvirt   = undef,
  # DEPRECATED PARAMETERS
  $live_migration_tunnelled            = undef,
) inherits nova::compute::libvirt::version {

  include nova::deps
  include nova::params

  if $live_migration_tunnelled != undef {
    warning('The live_migration_tunnelled parameter has been deprecated.')
  }

  $modular_libvirt_real = pick($modular_libvirt, $::nova::params::modular_libvirt)

  if $modular_libvirt_real and !$::nova::params::modular_libvirt_support {
    fail('Modular libvirt daemons are not supported in this distribution')
  }

  if $configure_nova {
    if $transport == 'ssh' and ($client_user or $client_port or !empty($client_extraparams)) {
      if $client_user {
        $prefix = "${client_user}@"
      } else {
        $prefix = ''
      }
      if $client_port {
        $suffix = ":${client_port}"
      } else {
        $suffix = ''
      }
      $extra_params = encode_url_queries_for_python($client_extraparams)
      $live_migration_uri = "qemu+${transport}://${prefix}%s${suffix}/system${extra_params}"
      $live_migration_scheme = $facts['os_service_default']
    } else {
      $live_migration_uri = $facts['os_service_default']
      $live_migration_scheme = $transport
    }

    nova_config {
      'libvirt/migration_inbound_addr':              value => $migration_inbound_addr;
      'libvirt/live_migration_uri':                  value => $live_migration_uri;
      'libvirt/live_migration_tunnelled':            value => pick($live_migration_tunnelled, $facts['os_service_default']);
      'libvirt/live_migration_with_native_tls':      value => $live_migration_with_native_tls;
      'libvirt/live_migration_bandwidth':            value => $live_migration_bandwidth;
      'libvirt/live_migration_downtime':             value => $live_migration_downtime;
      'libvirt/live_migration_downtime_steps':       value => $live_migration_downtime_steps;
      'libvirt/live_migration_downtime_delay':       value => $live_migration_downtime_delay;
      'libvirt/live_migration_completion_timeout':   value => $live_migration_completion_timeout;
      'libvirt/live_migration_timeout_action':       value => $live_migration_timeout_action;
      'libvirt/live_migration_inbound_addr':         value => $live_migration_inbound_addr;
      'libvirt/live_migration_scheme':               value => $live_migration_scheme;
      'libvirt/live_migration_permit_post_copy':     value => $live_migration_permit_post_copy;
      'libvirt/live_migration_permit_auto_converge': value => $live_migration_permit_auto_converge;
    }
  }

  if $configure_libvirt {
    Anchor['nova::config::begin']
    -> File<| tag == 'libvirt-file'|>
    -> File_line<| tag == 'libvirt-file_line'|>
    -> Anchor['nova::config::end']

    File<| tag == 'libvirt-file'|> ~> Service['libvirt']
    File_line<| tag == 'libvirt-file_line' |> ~> Service['libvirt']

    if $override_uuid {
      if ! $facts['libvirt_uuid'] {
        $host_uuid_real = pick(
          $host_uuid,
          generate('/bin/cat', '/proc/sys/kernel/random/uuid'))
        file { '/etc/libvirt/libvirt_uuid':
          content => $host_uuid_real,
          require => Package['libvirt'],
        }
      } else {
        $host_uuid_real = $facts['libvirt_uuid']
      }

      if $modular_libvirt_real {
        ['virtqemud', 'virtproxyd', 'virtsecretd', 'virtnodedevd', 'virtstoraged'].each |String $daemon| {
          create_resources("${daemon}_config", {
            'host_uuid' => {
              'value' => $host_uuid_real,
              'quote' => true,
            },
          })
        }
      } else {
        create_resources('libvirtd_config', {
          'host_uuid' => {
            'value' => $host_uuid_real,
            'quote' => true,
          },
        })
      }
    } else {
      if $host_uuid {
        warning('host_uuid has no effect when override_uuid is false')
      }
    }

    if $transport == 'tls' {
      $auth_tls_real  = $auth
      $auth_tcp_real  = $facts['os_service_default']
      $key_file_real  = $key_file
      $cert_file_real = $cert_file
      $ca_file_real   = $ca_file
      $crl_file_real  = $crl_file
    } elsif $transport == 'tcp' {
      $auth_tls_real  = $facts['os_service_default']
      $auth_tcp_real  = $auth
      $key_file_real  = $facts['os_service_default']
      $cert_file_real = $facts['os_service_default']
      $ca_file_real   = $facts['os_service_default']
      $crl_file_real  = $facts['os_service_default']
    } else {
      $auth_tls_real  = $facts['os_service_default']
      $auth_tcp_real  = $facts['os_service_default']
      $key_file_real  = $facts['os_service_default']
      $cert_file_real = $facts['os_service_default']
      $ca_file_real   = $facts['os_service_default']
      $crl_file_real  = $facts['os_service_default']
    }

    $libvirt_listen_config = $modular_libvirt_real ? {
      true    => 'virtproxyd_config',
      default => 'libvirtd_config'
    }

    create_resources( $libvirt_listen_config , {
      'auth_tls'  => { 'value' => $auth_tls_real,  'quote' => true },
      'auth_tcp'  => { 'value' => $auth_tcp_real,  'quote' => true },
      'key_file'  => { 'value' => $key_file_real,  'quote' => true },
      'cert_file' => { 'value' => $cert_file_real, 'quote' => true },
      'ca_file'   => { 'value' => $ca_file_real,   'quote' => true },
      'crl_file'  => { 'value' => $crl_file_real,  'quote' => true },
    })

    if $transport == 'tls' or $transport == 'tcp' {
      if versioncmp($libvirt_version, '5.6') < 0 {
        fail('libvirt version < 5.6 is no longer supported')
      }

      if $manage_service {
        $proxy_service = $modular_libvirt ? {
          true    => 'virtproxyd',
          default => 'libvirtd',
        }
        $socket_name = "${proxy_service}-${transport}"

        # This is the dummy resource to trigger exec to stop libvirtd.service.
        # libvirtd.service should be stopped before socket is started.
        # Otherwise, socket fails to start.
        exec { "check ${socket_name}.socket":
          command => '/usr/bin/true',
          path    => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          unless  => "systemctl -q is-active ${socket_name}.socket",
        }

        exec { "stop ${proxy_service}.service":
          command     => "systemctl -q stop ${proxy_service}.service",
          path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
          refreshonly => true,
        }

        if $modular_libvirt {
          Exec["stop ${proxy_service}.service"] -> Service<| title == 'virtproxyd' |>
        }

        service { $socket_name:
          ensure => 'running',
          name   => "${socket_name}.socket",
          enable => true,
        }

        Anchor['nova::service::begin']
        -> Exec["check ${socket_name}.socket"]
        ~> Exec["stop ${proxy_service}.service"]
        -> Service[$socket_name]
        ~> Anchor['nova::service::end']

        if is_service_default($listen_address) {
          file { "/etc/systemd/system/${socket_name}.socket":
            ensure  => absent,
            require => Anchor['nova::install::end']
          } ~> exec { 'systemd-damon-reload':
            command     => 'systemctl daemon-reload',
            path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
            refreshonly => true,
          } ~> Service[$socket_name]

        } else {
          $listen_address_real = normalize_ip_for_uri($listen_address)

          $default_listen_port = $transport ? {
            'tls'   => 16514,
            default => 16509
          }
          $listen_port = pick($client_port, $default_listen_port)

          # TODO(tkajinam): We have to completely override the socket file,
          #                 because dropin does not allow us to remove
          #                 ListenStream in the base file.
          file { "/etc/systemd/system/${socket_name}.socket":
            mode    => '0644',
            source  => "/usr/lib/systemd/system/${socket_name}.socket",
            replace => false,
            require => Anchor['nova::install::end'],
          } -> file_line { "${proxy_service}-${transport}.socket ListenStream":
            path  => "/etc/systemd/system/${socket_name}.socket",
            line  => "ListenStream=${listen_address_real}:${listen_port}",
            match => '^ListenStream=.*',
          } ~> exec { 'systemd-damon-reload':
            command     => 'systemctl daemon-reload',
            path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
            refreshonly => true,
          } ~> Service[$socket_name]
          File["/etc/systemd/system/${socket_name}.socket"] ~> Exec['systemd-damon-reload']
        }

        # We have to stop libvirtd.service to restart socket.
        Exec['systemd-damon-reload'] ~> Exec["stop ${proxy_service}.service"]

        if $modular_libvirt {
          Service["${proxy_service}-${transport}"] -> Service<| title == 'virtproxyd' |>
        } else {
          Service["${proxy_service}-${transport}"] -> Service<| title == 'libvirt' |>
        }
      }
    }
  }
}
