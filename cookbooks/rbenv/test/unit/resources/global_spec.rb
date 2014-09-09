require_relative "../spec_helper"
load_lw_resource("rbenv", "global")

describe Chef::Resource::RbenvGlobal do

  let(:resource) { described_class.new("antruby") }

  it "sets the default attribute to rbenv_version" do
    expect(resource.rbenv_version).to eq("antruby")
  end

  it "attribute user defaults to nil" do
    expect(resource.user).to be_nil
  end

  it "attribute user takes a String value" do
    resource.user("casper")
    expect(resource.user).to eq("casper")
  end

  it "attribute root_path defaults to nil" do
    expect(resource.root_path).to be_nil
  end

  it "attribute root_path takes a String value" do
    resource.root_path("C:\\wintowne")
    expect(resource.root_path).to eq("C:\\wintowne")
  end

  it "action defaults to :create" do
    expect(resource.action).to eq(:create)
  end

  it "#to_s includes user if provided" do
    resource.user("molly")
    expect(resource.to_s).to eq("rbenv_global[antruby] (molly)")
  end

  it "#to_s includes system label if user is not provided" do
    expect(resource.to_s).to eq("rbenv_global[antruby] (system)")
  end
end
