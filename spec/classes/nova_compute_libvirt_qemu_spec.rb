require 'spec_helper'

describe 'nova::compute::libvirt::qemu' do

  shared_examples_for 'nova compute libvirt with qemu' do

    context 'when not configuring qemu' do
      let :params do
        {
          :configure_qemu => false,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "rm max_files",
            "rm max_processes",
            "rm vnc_tls",
            "rm vnc_tls_x509_verify",
            "rm default_tls_x509_verify",
            "rm group",
            "rm memory_backing_dir",
            "rm nbd_tls",
        ],
      }) }
    end

    context 'when configuring qemu by default' do
      let :params do
        {
          :configure_qemu => true,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 1024",
            "set max_processes 4096",
            "set vnc_tls 0",
            "set vnc_tls_x509_verify 0",
            "set default_tls_x509_verify 1",
            "rm group",
            "rm memory_backing_dir",
            "set nbd_tls 0",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

    context 'when configuring qemu with overridden parameters' do
      let :params do
        {
          :configure_qemu => true,
          :max_files      => 32768,
          :max_processes  => 131072,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 32768",
            "set max_processes 131072",
            "set vnc_tls 0",
            "set vnc_tls_x509_verify 0",
            "set default_tls_x509_verify 1",
            "rm group",
            "rm memory_backing_dir",
            "set nbd_tls 0",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

    context 'when configuring qemu with group parameter' do
      let :params do
        {
          :configure_qemu     => true,
          :group              => 'openvswitch',
          :max_files          => 32768,
          :max_processes      => 131072,
          :memory_backing_dir => '/tmp',
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 32768",
            "set max_processes 131072",
            "set vnc_tls 0",
            "set vnc_tls_x509_verify 0",
            "set default_tls_x509_verify 1",
            "set group openvswitch",
            "set memory_backing_dir /tmp",
            "set nbd_tls 0",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

    context 'when configuring qemu with vnc_tls' do
      let :params do
        {
          :configure_qemu => true,
          :vnc_tls        => true,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 1024",
            "set max_processes 4096",
            "set vnc_tls 1",
            "set vnc_tls_x509_verify 1",
            "set default_tls_x509_verify 1",
            "rm group",
            "rm memory_backing_dir",
            "set nbd_tls 0",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

    context 'when configuring qemu with default_tls_verify enabled' do
      let :params do
        {
          :configure_qemu     => true,
          :default_tls_verify => true,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 1024",
            "set max_processes 4096",
            "set vnc_tls 0",
            "set vnc_tls_x509_verify 0",
            "set default_tls_x509_verify 1",
            "rm group",
            "rm memory_backing_dir",
            "set nbd_tls 0",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

    context 'when configuring qemu with vnc_tls_verify disabled' do
      let :params do
        {
          :configure_qemu => true,
          :vnc_tls        => true,
          :vnc_tls_verify => false,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 1024",
            "set max_processes 4096",
            "set vnc_tls 1",
            "set vnc_tls_x509_verify 0",
            "set default_tls_x509_verify 1",
            "rm group",
            "rm memory_backing_dir",
            "set nbd_tls 0",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

    context 'when configuring qemu with default_tls_verify disabled' do
      let :params do
        {
          :configure_qemu     => true,
          :default_tls_verify => false,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 1024",
            "set max_processes 4096",
            "set vnc_tls 0",
            "set vnc_tls_x509_verify 0",
            "set default_tls_x509_verify 0",
            "rm group",
            "rm memory_backing_dir",
            "set nbd_tls 0",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

    context 'when configuring qemu with nbd_tls and libvirt >= 4.5' do
      let :params do
        {
          :configure_qemu => true,
          :nbd_tls        => true,
        }
      end
      it { is_expected.to contain_augeas('qemu-conf-limits').with({
        :context => '/files/etc/libvirt/qemu.conf',
        :changes => [
            "set max_files 1024",
            "set max_processes 4096",
            "set vnc_tls 0",
            "set vnc_tls_x509_verify 0",
            "set default_tls_x509_verify 1",
            "rm group",
            "rm memory_backing_dir",
            "set nbd_tls 1",
        ],
        :tag     => 'qemu-conf-augeas',
      }) }
    end

  end

  on_supported_os({
     :supported_os => OSDefaults.get_supported_os
   }).each do |os,facts|
     context "on #{os}" do
       let (:facts) do
         facts.merge!(OSDefaults.get_facts())
       end

      it_configures 'nova compute libvirt with qemu'
     end
  end

end
