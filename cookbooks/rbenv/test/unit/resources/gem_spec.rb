require_relative "../spec_helper"
require "chef/provider/package/rubygems"
require_relative "../../../libraries/chef_rbenv_mixin"
require_relative "../../../libraries/chef_provider_package_rbenvrubygems"
load_lw_resource("rbenv", "gem")

describe Chef::Resource::RbenvGem do

  let(:resource) { described_class.new("creamcorn") }

  it "sets the default attribute to package_name" do
    expect(resource.package_name).to eq("creamcorn")
  end

  it "attribute rbenv_version defaults to global" do
    expect(resource.rbenv_version).to eq("global")
  end

  it "attribute rbenv_version takes a String value" do
    resource.rbenv_version("nextruby")
    expect(resource.rbenv_version).to eq("nextruby")
  end

  it "attribute version defaults to nil" do
    expect(resource.version).to be_nil
  end

  it "attribute version takes a String value" do
    resource.version("1.0.99")
    expect(resource.version).to eq("1.0.99")
  end

  it "attribute response_file defaults to nil" do
    expect(resource.response_file).to be_nil
  end

  it "attribute response_file takes a String value" do
    resource.response_file("/dont/think/so")
    expect(resource.response_file).to eq("/dont/think/so")
  end

  it "attribute source defaults to nil" do
    expect(resource.source).to be_nil
  end

  it "attribute source takes a String value" do
    resource.source("outthere")
    expect(resource.source).to eq("outthere")
  end

  it "attribute options defaults to nil" do
    expect(resource.options).to be_nil
  end

  it "attribute options takes a String value" do
    resource.options("--no-rdoc")
    expect(resource.options).to eq("--no-rdoc")
  end

  it "attribute options takes a Hash value" do
    resource.options({ one: "two" })
    expect(resource.options).to eq({ one: "two" })
  end

  it "attribute gem_binary defaults to nil" do
    expect(resource.gem_binary).to be_nil
  end

  it "attribute gem_binary takes a String value" do
    resource.gem_binary("/my/fav/gem")
    expect(resource.gem_binary).to eq("/my/fav/gem")
  end

  it "attribute user defaults to nil" do
    expect(resource.user).to be_nil
  end

  it "attribute user takes a String value" do
    resource.user("masha")
    expect(resource.user).to eq("masha")
  end

  it "attribute root_path defaults to nil" do
    expect(resource.root_path).to be_nil
  end

  it "attribute root_path takes a String value" do
    resource.root_path("C:\\crazytown")
    expect(resource.root_path).to eq("C:\\crazytown")
  end

  it "action defaults to :install" do
    expect(resource.action).to eq(:install)
  end

  it "actions include :upgrade" do
    expect(resource.allowed_actions).to include(:upgrade)
  end

  it "actions include :remove" do
    expect(resource.allowed_actions).to include(:remove)
  end

  it "actions include :purge" do
    expect(resource.allowed_actions).to include(:purge)
  end

  it "sets the provider to RbenvRubygems" do
    expect(resource.provider).to eq(Chef::Provider::Package::RbenvRubygems)
  end
end
