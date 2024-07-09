require 'spec_helper'

describe 'nova::scheduler' do
  let :pre_condition do
    'include nova'
  end

  shared_examples 'nova::scheduler' do
    it { is_expected.to contain_package('nova-scheduler').with(
      :name   => platform_params[:scheduler_package_name],
      :ensure => 'present'
    ) }

    it { is_expected.to contain_service('nova-scheduler').with(
      :name      => platform_params[:scheduler_service_name],
      :hasstatus => 'true',
      :ensure    => 'running'
    )}

    it { is_expected.to contain_nova_config('scheduler/workers').with_value(4) }
    it { is_expected.to contain_nova_config('scheduler/max_attempts').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/discover_hosts_in_cells_interval').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/query_placement_for_image_type_support').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/limit_tenants_to_placement_aggregate').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/placement_aggregate_required_for_tenants').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/max_placement_results').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/enable_isolated_aggregate_filtering').with_value('<SERVICE DEFAULT>') }
    it { is_expected.to contain_nova_config('scheduler/query_placement_for_routed_network_aggregates').with_value('<SERVICE DEFAULT>') }

    it { is_expected.to contain_class('nova::availability_zone') }

    context 'with manage_service as false' do
      let :params do
        {
          :manage_service => false
        }
      end
      it { is_expected.to_not contain_service('nova-scheduler') }
    end

    context 'with package version' do
      let :params do
        { :ensure_package => '2012.1-2' }
      end

      it { is_expected.to contain_package('nova-scheduler').with(
        :ensure => params[:ensure_package]
      )}
    end

    context 'with workers' do
      let :params do
        { :workers => 8 }
      end

      it { is_expected.to contain_nova_config('scheduler/workers').with_value(8) }
    end

    context 'with max_attempts' do
      let :params do
        { :max_attempts => 10 }
      end

      it { is_expected.to contain_nova_config('scheduler/max_attempts').with_value(10) }
    end

    context 'with discover_hosts_in_cells_interval' do
      let :params do
        { :discover_hosts_in_cells_interval => 15 }
      end

      it { is_expected.to contain_nova_config('scheduler/discover_hosts_in_cells_interval').with_value(15) }
    end

    context 'with query_placement_for_image_type_support' do
      let :params do
        { :query_placement_for_image_type_support => true }
      end

      it { is_expected.to contain_nova_config('scheduler/query_placement_for_image_type_support').with_value(true) }
    end

    context 'with limit_tenants_to_placement_aggregate' do
      let :params do
        { :limit_tenants_to_placement_aggregate => true }
      end

      it { is_expected.to contain_nova_config('scheduler/limit_tenants_to_placement_aggregate').with_value(true) }
    end

    context 'with placement_aggregate_required_for_tenants' do
      let :params do
        { :placement_aggregate_required_for_tenants => true }
      end

      it { is_expected.to contain_nova_config('scheduler/placement_aggregate_required_for_tenants').with_value(true) }
    end

    context 'with max_placement_results' do
      let :params do
        { :max_placement_results => 10 }
      end

      it { is_expected.to contain_nova_config('scheduler/max_placement_results').with_value(10) }
    end

    context 'with enable_isolated_aggregate_filtering' do
      let :params do
        { :enable_isolated_aggregate_filtering => true }
      end

      it { is_expected.to contain_nova_config('scheduler/enable_isolated_aggregate_filtering').with_value(true) }
    end

    context 'with query_placement_for_routed_network_aggregates' do
      let :params do
        { :query_placement_for_routed_network_aggregates => true }
      end

      it { is_expected.to contain_nova_config('scheduler/query_placement_for_routed_network_aggregates').with_value(true) }
    end

  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({ :os_workers => 4 }))
      end

      let (:platform_params) do
        case facts[:os]['family']
        when 'Debian'
          { :scheduler_package_name => 'nova-scheduler',
            :scheduler_service_name => 'nova-scheduler' }
        when 'RedHat'
          { :scheduler_package_name => 'openstack-nova-scheduler',
            :scheduler_service_name => 'openstack-nova-scheduler' }
        end
      end

      it_behaves_like 'nova::scheduler'
    end
  end
end
