require 'spec_helper'

describe 'nova::db::mysql' do

  shared_examples_for 'nova::db::mysql' do

    let :pre_condition do
      'include mysql::server'
    end

    let :required_params do
      { :password => "novapass" }
    end

    context 'with only required params' do
      let :params do
        required_params
      end

      it { is_expected.to contain_class('nova::deps') }

      it { is_expected.to contain_openstacklib__db__mysql('nova').with(
        :user     => 'nova',
        :password => 'novapass',
        :charset  => 'utf8',
        :collate  => 'utf8_general_ci',
      )}

      it { is_expected.to contain_openstacklib__db__mysql('nova_cell0').with(
        :user        => 'nova',
        :password    => 'novapass',
        :charset     => 'utf8',
        :collate     => 'utf8_general_ci',
        :create_user => false,
      )}
    end

    context 'overriding allowed_hosts param to array' do
      let :params do
        { :allowed_hosts  => ['127.0.0.1','%'] }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('nova').with(
        :user          => 'nova',
        :password      => 'novapass',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%'],
      )}
    end

    context 'overriding allowed_hosts param to string' do
      let :params do
        { :allowed_hosts  => '192.168.1.1' }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('nova').with(
        :user          => 'nova',
        :password      => 'novapass',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1',
      )}
    end

    context 'when overriding charset' do
      let :params do
        { :charset => 'latin1' }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('nova').with(
        :charset => 'latin1',
      )}
    end

    context 'when disabling cell0 setup' do
      let :params do
        { :setup_cell0 => false }.merge(required_params)
      end

      it { is_expected.to_not contain_openstacklib__db__mysql('nova_cell0') }
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_configures 'nova::db::mysql'
    end
  end

end
