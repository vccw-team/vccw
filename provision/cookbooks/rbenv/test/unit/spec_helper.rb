require "chefspec"
require "chefspec/berkshelf"

def load_lw_resource(cb, lwrp)
  require "chef/resource/lwrp_base"
  unless Chef::Resource.const_defined?(class_name_for_lwrp(cb, lwrp))
    Chef::Resource::LWRPBase.build_from_file(
      cb,
      File.join(File.dirname(__FILE__), %W{.. .. resources #{lwrp}.rb}),
      nil
    )
  end
end

def load_lw_provider(cb, lwrp)
  require "chef/provider/lwrp_base"
  unless Chef::Provider.const_defined?(class_name_for_lwrp(cb, lwrp))
    Chef::Provider::LWRPBase.build_from_file(
      cb,
      File.join(File.dirname(__FILE__), %W{.. .. providers #{lwrp}.rb}),
      nil
    )
  end
end

def class_name_for_lwrp(cb, lwrp)
  require "chef/mixin/convert_to_class_name"
  Chef::Mixin::ConvertToClassName.convert_to_class_name(
    Chef::Mixin::ConvertToClassName.filename_to_qualified_string(cb, lwrp)
  )
end
