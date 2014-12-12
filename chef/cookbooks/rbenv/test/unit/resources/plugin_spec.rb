require_relative "../spec_helper"
load_lw_resource("rbenv", "plugin")

describe Chef::Resource::RbenvPlugin do

  let(:resource) { described_class.new("rbenv-goodies") }

  it "sets the default attribute to name" do
    expect(resource.name).to eq("rbenv-goodies")
  end

  it "attribute git_url defaults to nil" do
    expect(resource.git_url).to be_nil
  end

  it "attribute git_url takes a String value" do
    resource.git_url("https://example.com/rbenv-goodies.git")
    expect(resource.git_url).to eq("https://example.com/rbenv-goodies.git")
  end

  it "attribute git_ref defaults to nil" do
    expect(resource.git_ref).to be_nil
  end

  it "attribute git_ref takes a String value" do
    resource.git_ref("abc123")
    expect(resource.git_ref).to eq("abc123")
  end

  it "attribute user defaults to nil" do
    expect(resource.user).to be_nil
  end

  it "attribute user takes a String value" do
    resource.user("abed")
    expect(resource.user).to eq("abed")
  end

  it "attribute root_path defaults to nil" do
    expect(resource.root_path).to be_nil
  end

  it "attribute root_path takes a String value" do
    resource.root_path("/tmp/root")
    expect(resource.root_path).to eq("/tmp/root")
  end

  it "action defaults to :install" do
    expect(resource.action).to eq(:install)
  end

  it "#to_s includes user if provided" do
    resource.user("molly")
    expect(resource.to_s).to eq("rbenv_plugin[rbenv-goodies] (molly)")
  end

  it "#to_s includes system label if user is not provided" do
    expect(resource.to_s).to eq("rbenv_plugin[rbenv-goodies] (system)")
  end
end
