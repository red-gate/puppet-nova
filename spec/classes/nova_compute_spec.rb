require 'spec_helper'

describe 'nova::compute' do

  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova-compute' do

    context 'with default parameters' do

      it 'installs nova-compute package and service' do
        is_expected.to contain_service('nova-compute').with({
          :name      => platform_params[:nova_compute_service],
          :ensure    => 'running',
          :hasstatus => true,
          :enable    => true,
          :tag       => 'nova-service'
        })
        is_expected.to contain_package('nova-compute').with({
          :name => platform_params[:nova_compute_package],
          :tag  => ['openstack', 'nova-package']
        })
      end

      it { is_expected.to contain_nova_config('DEFAULT/allow_resize_to_same_host').with(:value => 'false') }
      it { is_expected.to contain_nova_config('DEFAULT/resize_confirm_window').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:value => '<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/resume_guests_state_on_host_boot').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to_not contain_nova_config('vnc/novncproxy_base_url') }
      it { is_expected.to contain_nova_config('key_manager/backend').with_value('nova.keymgr.conf_key_mgr.ConfKeyManager') }
      it { is_expected.to contain_nova_config('barbican/barbican_endpoint').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('barbican/barbican_api_version').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('barbican/auth_endpoint').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('glance/verify_glance_signatures').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/max_concurrent_live_migrations').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('compute/consecutive_build_service_disable_threshold').with_value('<SERVICE DEFAULT>') }
      it { is_expected.to contain_nova_config('DEFAULT/reserved_huge_pages').with_value('<SERVICE DEFAULT>') }

      it { is_expected.to_not contain_package('cryptsetup').with( :ensure => 'present' )}

      it { is_expected.to_not contain_package('bridge-utils').with(
        :ensure => 'present',
      ) }

      it { is_expected.to contain_nova_config('DEFAULT/force_raw_images').with(:value => true) }

      it 'configures availability zones' do
        is_expected.to contain_nova_config('DEFAULT/default_availability_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/default_schedule_zone').with_value('<SERVICE DEFAULT>')
        is_expected.to contain_nova_config('DEFAULT/internal_service_availability_zone').with_value('<SERVICE DEFAULT>')
      end

      it { is_expected.to contain_nova_config('DEFAULT/heal_instance_info_cache_interval').with_value('60') }

      it 'installs genisoimage package and sets config_drive_format' do
        is_expected.to contain_nova_config('DEFAULT/config_drive_format').with(:value => '<SERVICE DEFAULT>')
        is_expected.to contain_package('genisoimage').with(
          :ensure => 'present',
        )
        is_expected.to contain_package('genisoimage').that_requires('Anchor[nova::install::begin]')
        is_expected.to contain_package('genisoimage').that_comes_before('Anchor[nova::install::end]')
      end
    end

    context 'with overridden parameters' do
      let :params do
        { :enabled                            => false,
          :ensure_package                     => '2012.1-2',
          :vncproxy_host                      => '127.0.0.1',
          :force_raw_images                   => false,
          :reserved_host_memory               => '0',
          :heal_instance_info_cache_interval  => '120',
          :config_drive_format                => 'vfat',
          :resize_confirm_window              => '3',
          :vcpu_pin_set                       => ['4-12','^8','15'],
          :resume_guests_state_on_host_boot   => true,
          :keymgr_backend                     => 'castellan.key_manager.barbican_key_manager.BarbicanKeyManager',
          :barbican_endpoint                  => 'http://localhost',
          :barbican_api_version               => 'v1',
          :barbican_auth_endpoint             => 'http://127.0.0.1:5000/v3',
          :max_concurrent_live_migrations     => '4',
          :verify_glance_signatures           => true,
          :consecutive_build_service_disable_threshold => '9',
        }
      end

      it 'installs nova-compute package and service' do
        is_expected.to contain_service('nova-compute').with({
          :name      => platform_params[:nova_compute_service],
          :ensure    => 'stopped',
          :hasstatus => true,
          :enable    => false,
          :tag       => 'nova-service'
        })
        is_expected.to contain_package('nova-compute').with({
          :name   => platform_params[:nova_compute_package],
          :ensure => '2012.1-2',
          :tag    => ['openstack', 'nova-package']
        })
      end

      it 'configures ironic in nova.conf' do
        is_expected.to contain_nova_config('DEFAULT/reserved_host_memory_mb').with_value('0')
      end

      it 'configures barbican service' do
        is_expected.to contain_nova_config('key_manager/backend').with_value('castellan.key_manager.barbican_key_manager.BarbicanKeyManager')
        is_expected.to contain_nova_config('barbican/barbican_endpoint').with_value('http://localhost')
        is_expected.to contain_nova_config('barbican/barbican_api_version').with_value('v1')
        is_expected.to contain_nova_config('barbican/auth_endpoint').with_value('http://127.0.0.1:5000/v3')
        is_expected.to contain_package('cryptsetup').with( :ensure => 'present' )
      end

      it 'configures vnc in nova.conf' do
        is_expected.to contain_nova_config('vnc/enabled').with_value(true)
        is_expected.to contain_nova_config('vnc/vncserver_proxyclient_address').with_value('127.0.0.1')
        is_expected.to contain_nova_config('vnc/keymap').with_value('en-us')
        is_expected.to contain_nova_config('vnc/novncproxy_base_url').with_value(
          'http://127.0.0.1:6080/vnc_auto.html'
        )
      end

      it { is_expected.to contain_nova_config('DEFAULT/heal_instance_info_cache_interval').with_value('120') }

      it { is_expected.to contain_nova_config('DEFAULT/force_raw_images').with(:value => false) }

      it { is_expected.to contain_nova_config('DEFAULT/resize_confirm_window').with_value('3') }

      it { is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:value => '4-12,^8,15') }

      it { is_expected.to contain_nova_config('DEFAULT/max_concurrent_live_migrations').with_value('4') }

      it { is_expected.to contain_nova_config('compute/consecutive_build_service_disable_threshold').with_value('9') }

      it { is_expected.to contain_nova_config('DEFAULT/resume_guests_state_on_host_boot').with_value(true) }
      it { is_expected.to contain_nova_config('glance/verify_glance_signatures').with_value(true) }

      it 'configures nova config_drive_format to vfat' do
        is_expected.to contain_nova_config('DEFAULT/config_drive_format').with_value('vfat')
        is_expected.to_not contain_package('genisoimage').with(
          :ensure => 'present',
        )
      end
    end

    context 'with reserved_huge_pages string' do
      let :params do
        {
            :reserved_huge_pages => "foo"
        }
      end
      it 'configures nova reserved_huge_pages entries' do
        is_expected.to contain_nova_config('DEFAULT/reserved_huge_pages').with(
          'value' => 'foo'
        )
      end
    end

    context 'with reserved_huge_pages array' do
      let :params do
        {
            :reserved_huge_pages => ["foo", "bar"]
        }
      end
      it 'configures nova reserved_huge_pages entries' do
        is_expected.to contain_nova_config('DEFAULT/reserved_huge_pages').with(
          'value' => ['foo','bar']
        )
      end
    end

    context 'with barbican deprecated parameters' do
      let :params do
        {
          :keymgr_api_class => 'castellan.key_manager.barbican_key_manager.BarbicanKeyManager',
        }
      end
      it 'should set keymgr parameter' do
        is_expected.to contain_nova_config('key_manager/backend').with_value('castellan.key_manager.barbican_key_manager.BarbicanKeyManager')
        is_expected.to contain_package('cryptsetup').with( :ensure => 'present' )
      end
    end

    context 'when vcpu_pin_set and pci params are empty' do
      let :params do
        { :vcpu_pin_set    => ""}
      end

      it 'clears vcpu_pin_set configuration' do
        is_expected.to contain_nova_config('DEFAULT/vcpu_pin_set').with(:value => '<SERVICE DEFAULT>')
      end
    end

    context 'with neutron_enabled set to false' do
      let :params do
        { :neutron_enabled => false }
      end

      it 'installs bridge-utils package for nova-network' do
        is_expected.to contain_package('bridge-utils').with(
          :ensure => 'present',
        )
        is_expected.to contain_package('bridge-utils').that_requires('Anchor[nova::install::begin]')
        is_expected.to contain_package('bridge-utils').that_comes_before('Anchor[nova::install::end]')
      end

    end

    context 'with install_bridge_utils set to false' do
      let :params do
        { :install_bridge_utils => false }
      end

      it 'does not install bridge-utils package for nova-network' do
        is_expected.to_not contain_package('bridge-utils').with(
          :ensure => 'present',
        )
      end

    end

    context 'with vnc_enabled set to false' do
      let :params do
        { :vnc_enabled => false }
      end

      it 'disables vnc in nova.conf' do
        is_expected.to contain_nova_config('vnc/enabled').with_value(false)
        is_expected.to contain_nova_config('vnc/vncserver_proxyclient_address').with_ensure('absent')
        is_expected.to contain_nova_config('vnc/keymap').with_ensure('absent')
        is_expected.to_not contain_nova_config('vnc/novncproxy_base_url')
      end
    end

    context 'with force_config_drive parameter set to true' do
      let :params do
        { :force_config_drive => true }
      end

      it { is_expected.to contain_nova_config('DEFAULT/force_config_drive').with_value(true) }
    end

    context 'while not managing service state' do
      let :params do
        { :enabled           => false,
          :manage_service    => false,
        }
      end

      it { is_expected.to contain_service('nova-compute').without_ensure }
    end

    context 'with instance_usage_audit parameter set to false' do
      let :params do
        { :instance_usage_audit => false, }
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit').with_ensure('absent') }
      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit_period').with_ensure('absent') }
    end

    context 'with instance_usage_audit parameter and wrong period' do
      let :params do
        { :instance_usage_audit        => true,
          :instance_usage_audit_period => 'fake', }
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit').with_ensure('absent') }
      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit_period').with_ensure('absent') }
    end

    context 'with instance_usage_audit parameter and period' do
      let :params do
        { :instance_usage_audit        => true,
          :instance_usage_audit_period => 'year', }
      end

      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit').with_value(true) }
      it { is_expected.to contain_nova_config('DEFAULT/instance_usage_audit_period').with_value('year') }
    end

    context 'with vnc_keymap set to fr' do
      let :params do
        { :vnc_keymap => 'fr', }
      end

      it { is_expected.to contain_nova_config('vnc/keymap').with_value('fr') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          { :nova_compute_package => 'nova-compute',
            :nova_compute_service => 'nova-compute' }
        when 'RedHat'
          { :nova_compute_package => 'openstack-nova-compute',
            :nova_compute_service => 'openstack-nova-compute' }
        end
      end
      it_behaves_like 'nova-compute'
    end
  end

end
