require 'spec_helper'

describe 'nova::network::neutron' do
  let :default_params do
    {
      :auth_type               => 'password',
      :timeout                 => '30',
      :project_name            => 'services',
      :project_domain_name     => 'Default',
      :system_scope            => '<SERVICE DEFAULT>',
      :region_name             => 'RegionOne',
      :username                => 'neutron',
      :user_domain_name        => 'Default',
      :auth_url                => 'http://127.0.0.1:5000/v3',
      :valid_interfaces        => '<SERVICE DEFAULT>',
      :endpoint_override       => '<SERVICE DEFAULT>',
      :http_retries            => '<SERVICE DEFAULT>',
      :service_type            => '<SERVICE DEFAULT>',
      :ovs_bridge              => '<SERVICE DEFAULT>',
      :extension_sync_interval => '<SERVICE DEFAULT>',
      :vif_plugging_is_fatal   => '<SERVICE DEFAULT>',
      :vif_plugging_timeout    => '<SERVICE DEFAULT>',
      :default_floating_pool   => '<SERVICE DEFAULT>',
    }
  end

  let :params do
    {
      :password => 's3cr3t'
    }
  end

  shared_examples 'nova::network::neutron' do
    context 'with required parameters' do
      it 'configures neutron endpoint in nova.conf' do
        should contain_nova_config('neutron/password').with_value(params[:password]).with_secret(true)
        should contain_nova_config('neutron/default_floating_pool').with_value(default_params[:default_floating_pool])
        should contain_nova_config('neutron/auth_type').with_value(default_params[:auth_type])
        should contain_nova_config('neutron/timeout').with_value(default_params[:timeout])
        should contain_nova_config('neutron/project_name').with_value(default_params[:project_name])
        should contain_nova_config('neutron/project_domain_name').with_value(default_params[:project_domain_name])
        should contain_nova_config('neutron/system_scope').with_value(default_params[:system_scope])
        should contain_nova_config('neutron/region_name').with_value(default_params[:region_name])
        should contain_nova_config('neutron/username').with_value(default_params[:username])
        should contain_nova_config('neutron/user_domain_name').with_value(default_params[:user_domain_name])
        should contain_nova_config('neutron/auth_url').with_value(default_params[:auth_url])
        should contain_nova_config('neutron/valid_interfaces').with_value(default_params[:valid_interfaces])
        should contain_nova_config('neutron/endpoint_override').with_value(default_params[:endpoint_override])
        should contain_nova_config('neutron/http_retries').with_value(default_params[:http_retries])
        should contain_nova_config('neutron/service_type').with_value(default_params[:service_type])
        should contain_nova_config('neutron/extension_sync_interval').with_value(default_params[:extension_sync_interval])
        should contain_nova_config('neutron/ovs_bridge').with_value(default_params[:ovs_bridge])
      end

      it 'configures neutron vif plugging events in nova.conf' do
        should contain_nova_config('DEFAULT/vif_plugging_is_fatal').with_value(default_params[:vif_plugging_is_fatal])
        should contain_nova_config('DEFAULT/vif_plugging_timeout').with_value(default_params[:vif_plugging_timeout])
      end
    end

    context 'when overriding class parameters' do
      before do
        params.merge!(
          :timeout                 => '30',
          :project_name            => 'openstack',
          :project_domain_name     => 'openstack_domain',
          :region_name             => 'RegionTwo',
          :username                => 'neutron2',
          :user_domain_name        => 'neutron_domain',
          :auth_url                => 'http://10.0.0.1:5000/v2',
          :valid_interfaces        => 'internal,public',
          :endpoint_override       => 'http://127.0.0.1:9696',
          :http_retries            => 3,
          :service_type            => 'network',
          :ovs_bridge              => 'br-int',
          :extension_sync_interval => 600,
          :vif_plugging_is_fatal   => true,
          :vif_plugging_timeout    => 300,
          :default_floating_pool   => 'nova'
        )
      end

      it 'configures neutron endpoint in nova.conf' do
        should contain_nova_config('neutron/password').with_value(params[:password]).with_secret(true)
        should contain_nova_config('neutron/default_floating_pool').with_value(params[:default_floating_pool])
        should contain_nova_config('neutron/timeout').with_value(params[:timeout])
        should contain_nova_config('neutron/project_name').with_value(params[:project_name])
        should contain_nova_config('neutron/project_domain_name').with_value(params[:project_domain_name])
        should contain_nova_config('neutron/system_scope').with_value(default_params[:system_scope])
        should contain_nova_config('neutron/region_name').with_value(params[:region_name])
        should contain_nova_config('neutron/username').with_value(params[:username])
        should contain_nova_config('neutron/user_domain_name').with_value(params[:user_domain_name])
        should contain_nova_config('neutron/auth_url').with_value(params[:auth_url])
        should contain_nova_config('neutron/valid_interfaces').with_value(params[:valid_interfaces])
        should contain_nova_config('neutron/endpoint_override').with_value(params[:endpoint_override])
        should contain_nova_config('neutron/http_retries').with_value(params[:http_retries])
        should contain_nova_config('neutron/service_type').with_value(params[:service_type])
        should contain_nova_config('neutron/extension_sync_interval').with_value(params[:extension_sync_interval])
        should contain_nova_config('neutron/ovs_bridge').with_value(params[:ovs_bridge])
      end

      it 'configures neutron vif plugging events in nova.conf' do
        should contain_nova_config('DEFAULT/vif_plugging_is_fatal').with_value(params[:vif_plugging_is_fatal])
        should contain_nova_config('DEFAULT/vif_plugging_timeout').with_value(params[:vif_plugging_timeout])
      end
    end

    context 'when valid_interfaces is an array' do
      before do
        params.merge!(
          :valid_interfaces => ['internal', 'public']
        )
      end
      it 'configures the valid_interfaces parameter with a comma-separated string' do
        is_expected.to contain_nova_config('neutron/valid_interfaces').with_value('internal,public')
      end
    end

    context 'when system_scope is set' do
      before do
        params.merge!(
          :system_scope => 'all'
        )
      end
      it 'configures system-scoped credential' do
        should contain_nova_config('neutron/project_name').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('neutron/project_domain_name').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('neutron/system_scope').with_value('all')
      end
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge(OSDefaults.get_facts())
      end

      it_behaves_like 'nova::network::neutron'
    end
  end
end
