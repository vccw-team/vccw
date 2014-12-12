actions :install

default_action :install

attribute :name,      kind_of: String, name_attribute: true
attribute :git_url,   kind_of: String
attribute :git_ref,   kind_of: String
attribute :user,      kind_of: String
attribute :root_path, kind_of: String

def to_s
  "#{super} (#{@user || 'system'})"
end
