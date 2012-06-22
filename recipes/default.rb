#
# Cookbook Name:: upgrade-vagrant-ruby
# Recipe:: default
#

package = "ruby_1.9.3-p194-1_amd64.deb"
file_path = "/tmp/#{package}.deb"

remote_file package do
  path file_path
  source "http://ruby-packages-ubuntu-precise.googlecode.com/files/#{package}"
end if !File.exists?(file_path)

package "ruby" do
  action :install
  source file_path
  provider Chef::Provider::Package::Dpkg
end

script "replace_ruby" do
  interpreter "bash"
  user "root"
  environment ({'HOME' => '/root'})
  cwd "/tmp"
  code <<-EOH
    source /etc/environment
    echo "PATH=$PATH:/opt/ruby/bin" > /etc/profile.d/vagrant_ruby.sh
    source /etc/profile.d/vagrant_ruby.sh
    rm -rf /opt/vagrant_ruby
  EOH
end