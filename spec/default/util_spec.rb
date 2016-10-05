# http://serverspec.org/resource_types.html
# http://serverspec.org/advanced_tips.html

# testing operating system specific
#
# either:
#
# if os[:family] == 'redhat'
# if os[:release] == 7
# if os[:arch] == 'x86_64'
#
#   nested:
# if os[:family] == 'redhat'
#   if os[:release] == 7
#     describe resource(...) do
#     end
#   else
#     describe resource(...) do
#     end
#   end
#
# or:
#
# describe file('...'), :if => os[:family] == 'archlinux' do ... end
#
# or multiple OS share the same test data
#
# describe file('...'), :if => ['archlinux', 'redhat'].include?(os[:family]) do ... end

require 'spec_helper'

describe 'Testing for installed packages' do
  describe package('python-httplib2'), :if => ['archlinux', 'debian', 'ubuntu'].include?(os[:family]) do
    it { should be_installed }
  end

  %w[
    python-httplib2
    libselinux-python
    libsemanage-python
    policycoreutils-python
  ].each do |pkg|
    describe package(pkg), :if => os[:family] == 'redhat' do
      it { should be_installed }
    end
  end

end

describe 'Testing ansible local facts' do
  describe file('/etc/ansible/facts.d/util.fact') do
    it { should be_file }
    it { should be_mode '644' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its(:content) { should match /"role_version": "2\.0\.5"/ }
    its(:content) { should match /"template_use_cow": "True"/ }
    its(:content) { should match /"persistent_data_path": "\/usr\/local\/src\/ansible\/data"/ }
    its(:content) { should match /"allow_reload": "True"/ }
    its(:content) { should match /"allow_restart": "True"/ }
  end

  describe file('/etc/ansible/facts.d/util.fact'), :if => ['archlinux', 'debian', 'redhat'].include?(os[:family]) do
    its(:content) { should match /"system": "systemd"/ }
    its(:content) { should match /"service_dir": "\/etc\/systemd\/system"/ }
    its(:content) { should match /"service_mode": "644"/ }
  end

  describe file('/etc/ansible/facts.d/util.fact'), :if => ['archlinux', 'redhat'].include?(os[:family]) do
    its(:content) { should match /"package_state": "present"/ }
  end

  describe file('/etc/ansible/facts.d/util.fact'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
    its(:content) { should match /"package_state": "installed"/ }
  end

  describe file('/etc/ansible/facts.d/util.fact'), :if => os[:family] == 'ubuntu' do
    its(:content) { should match /"system": "upstart"/ }
    its(:content) { should match /"service_dir": "\/etc\/init"/ }
    its(:content) { should match /"service_mode": "644"/ }
    its(:content) { should match /"cache_valid_time": "3600"/ }
  end
end
