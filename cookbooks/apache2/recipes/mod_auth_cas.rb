include_recipe "apache2"

if node['apache']['mod_auth_cas']['from_source']

  package "httpd-devel" do
    package_name value_for_platform_family(
      ["rhel", "fedora", "suse"] => "httpd-devel",
      "debian" => "apache2-dev"
    )
  end

  git '/tmp/mod_auth_cas' do
    repository 'git://github.com/Jasig/mod_auth_cas.git'
    revision node['apache']['mod_auth_cas']['source_revision']
    notifies :run, 'execute[compile mod_auth_cas]', :immediately
  end

  execute 'compile mod_auth_cas' do
    command './configure && make && make install'
    cwd '/tmp/mod_auth_cas'
    not_if "test -f #{node['apache']['libexecdir']}/mod_auth_cas.so"
  end

  template "#{node['apache']['dir']}/mods-available/auth_cas.load" do
    source 'mods/auth_cas.load.erb'
    owner 'root'
    group node['apache']['root_group']
    mode 00644
  end

else
  case node['platform_family']
  when "debian"

    package "libapache2-mod-auth-cas"

  when "rhel", "fedora"

    yum_package "mod_auth_cas" do
      notifies :run, "execute[generate-module-list]", :immediately
    end

    file "#{node['apache']['dir']}/conf.d/auth_cas.conf" do
      action :delete
      backup false
    end

  end
end

apache_module 'auth_cas' do
  conf true
end

directory "#{node['apache']['cache_dir']}/mod_auth_cas" do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00700
end
