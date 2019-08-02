require 'spec_helper'

describe 'nova::cinder' do

  shared_examples 'nova::cinder' do
    context 'with required parameters' do

      it 'configures cinder in nova.conf' do
        should contain_nova_config('cinder/password').with_value('<SERVICE DEFAULT>').with_secret(true)
        should contain_nova_config('cinder/auth_type').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('cinder/auth_url').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('cinder/timeout').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('cinder/region_name').with_value('<SERVICE DEFAULT>')
        should contain_nova_config('cinder/project_name').with_value('services')
        should contain_nova_config('cinder/project_domain_name').with_value('Default')
        should contain_nova_config('cinder/username').with_value('cinder')
        should contain_nova_config('cinder/user_domain_name').with_value('Default')
      end

    end

    context 'when specified parameters' do
      let :params do
        {
          :password            => 's3cr3t',
          :auth_type           => 'v3password',
          :auth_url            => 'http://10.0.0.10:5000/v3',
          :timeout             => 60,
          :region_name         => 'RegionOne',
        }
      end

      it 'configures cinder in nova.conf' do
        should contain_nova_config('cinder/password').with_value('s3cr3t').with_secret(true)
        should contain_nova_config('cinder/auth_type').with_value('v3password')
        should contain_nova_config('cinder/auth_url').with_value('http://10.0.0.10:5000/v3')
        should contain_nova_config('cinder/timeout').with_value('60')
        should contain_nova_config('cinder/region_name').with_value('RegionOne')
        should contain_nova_config('cinder/project_name').with_value('services')
        should contain_nova_config('cinder/project_domain_name').with_value('Default')
        should contain_nova_config('cinder/username').with_value('cinder')
        should contain_nova_config('cinder/user_domain_name').with_value('Default')
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

      it_behaves_like 'nova::cinder'
    end
  end
end
