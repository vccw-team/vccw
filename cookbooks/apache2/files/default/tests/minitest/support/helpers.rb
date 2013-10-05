module Helpers
  module Apache
    require 'chef/mixin/shell_out'
    include Chef::Mixin::ShellOut
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources

    def apache_config_parses?
      acp = shell_out("#{node['apache']['binary']} -t")
      acp.exitstatus == 0
    end

    def apache_configured_ports
      port_config = File.read("#{node['apache']['dir']}/ports.conf")
      port_config.scan(/^Listen ([0-9]+)/).flatten.map { |p| p.to_i }
    end

    def apache_enabled_modules
      apache_modules = shell_out("#{node['apache']['binary']} -M")
      apache_modules.send(
        if node['platform_family'] == 'rhel' && node['platform_version'].to_f < 6.0
          :stderr
        else
          :stdout
        end
      ).split.select! { |i| i =~ /_module$/ }
    end

    def apache_service
      service(
        case node['platform']
        when "debian", "ubuntu" then "apache2"
        when "freebsd" then "apache22"
        else "httpd"
        end
      )
    end

    def config
      file(
        case node['platform']
        when "debian", "ubuntu" then "#{node['apache']['dir']}/apache2.conf"
        when "freebsd" then "#{node['apache']['dir']}/httpd.conf"
        else "#{node['apache']['dir']}/conf/httpd.conf"
        end
      )
    end

    def ran_recipe?(recipe)
      if Chef::VERSION < "11.0"
        seen_recipes = node.run_state[:seen_recipes]
        recipes = seen_recipes.keys.each { |i| i }
      else
        recipes = run_context.loaded_recipes
      end
      if recipes.empty? and Chef::Config[:solo]
        #If you have roles listed in your run list they are NOT expanded
        recipes = node.run_list.map {|item| item.name if item.type == :recipe }
      end
      recipes.include?(recipe)
    end

  end
end
