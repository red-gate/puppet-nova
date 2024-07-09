# Unit tests for nova::compute::libvirt::libvirtd class
#
require 'spec_helper'

describe 'nova::compute::libvirt::libvirtd' do

  let :pre_condition do
    <<-eos
    include nova
    include nova::compute
    include nova::compute::libvirt
eos
  end

  shared_examples_for 'nova-compute-libvirt-libvirtd' do

    context 'with default parameters' do
      let :params do
        {}
      end

      it { is_expected.to contain_class('nova::deps')}
      it { is_expected.to contain_class('nova::compute::libvirt::libvirtd')}

      it { is_expected.to contain_libvirtd_config('log_level').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_libvirtd_config('log_outputs').with_value('<SERVICE DEFAULT>').with_quote(true)}
      it { is_expected.to contain_libvirtd_config('log_filters').with_value('<SERVICE DEFAULT>').with_quote(true)}
      it { is_expected.to contain_libvirtd_config('max_clients').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_libvirtd_config('admin_max_clients').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_libvirtd_config('max_client_requests').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_libvirtd_config('admin_max_client_requests').with_value('<SERVICE DEFAULT>')}
      it { is_expected.to contain_libvirtd_config('tls_priority').with_value('<SERVICE DEFAULT>').with_quote(true)}
      it { is_expected.to contain_libvirtd_config('ovs_timeout').with_value('<SERVICE DEFAULT>')}
    end

    context 'with specified parameters' do
      let :params do
        { :log_level                 => 3,
          :log_outputs               => '3:syslog',
          :log_filters               => '1:logging 4:object 4:json 4:event 1:util',
          :max_clients               => 1024,
          :admin_max_clients         => 5,
          :max_client_requests       => 42,
          :admin_max_client_requests => 55,
          :tls_priority              => 'NORMAL',
          :ovs_timeout               => 20,
        }
      end

      it { is_expected.to contain_class('nova::deps')}
      it { is_expected.to contain_class('nova::compute::libvirt::libvirtd')}

      it { is_expected.to contain_libvirtd_config('log_level').with_value(params[:log_level])}
      it { is_expected.to contain_libvirtd_config('log_outputs').with_value(params[:log_outputs]).with_quote(true)}
      it { is_expected.to contain_libvirtd_config('log_filters').with_value(params[:log_filters]).with_quote(true)}
      it { is_expected.to contain_libvirtd_config('max_clients').with_value(params[:max_clients])}
      it { is_expected.to contain_libvirtd_config('admin_max_clients').with_value(params[:admin_max_clients])}
      it { is_expected.to contain_libvirtd_config('max_client_requests').with_value(params[:max_client_requests])}
      it { is_expected.to contain_libvirtd_config('admin_max_client_requests').with_value(params[:admin_max_client_requests])}
      it { is_expected.to contain_libvirtd_config('tls_priority').with_value(params[:tls_priority]).with_quote(true)}
      it { is_expected.to contain_libvirtd_config('ovs_timeout').with_value(params[:ovs_timeout])}
    end

    context 'with array values' do
      let :params do
        {
          :log_outputs => ['3:syslog', '3:stderr'],
          :log_filters => ['1:logging', '4:object', '4:json', '4:event', '1:util'],
        }
      end

      it { is_expected.to contain_libvirtd_config('log_outputs').with_value('3:syslog 3:stderr').with_quote(true)}
      it { is_expected.to contain_libvirtd_config('log_filters').with_value('1:logging 4:object 4:json 4:event 1:util').with_quote(true)}
    end
  end

  on_supported_os({
     :supported_os => OSDefaults.get_supported_os
   }).each do |os,facts|
     context "on #{os}" do
       let (:facts) do
         facts.merge!(OSDefaults.get_facts())
       end

       it_configures 'nova-compute-libvirt-libvirtd'
     end
  end

end
