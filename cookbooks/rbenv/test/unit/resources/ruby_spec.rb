require_relative "../spec_helper"
load_lw_resource("rbenv", "ruby")

describe Chef::Resource::RbenvRuby do

  let(:resource) { described_class.new("antruby") }

  it "sets the default attribute to definition" do
    expect(resource.definition).to eq("antruby")
  end

  it "attribute definition_file defaults to nil" do
    expect(resource.definition_file).to be_nil
  end

  it "attribute definition_file takes a String value" do
    resource.definition_file("/blah/blah/rubay")
    expect(resource.definition_file).to eq("/blah/blah/rubay")
  end

  it "attribute root_path defaults to nil" do
    expect(resource.root_path).to be_nil
  end

  it "attribute root_path takes a String value" do
    resource.root_path("/rootness/path")
    expect(resource.root_path).to eq("/rootness/path")
  end

  it "attribute user defaults to nil" do
    expect(resource.user).to be_nil
  end

  it "attribute user takes a String value" do
    resource.user("curious_george")
    expect(resource.user).to eq("curious_george")
  end

  it "action defaults to :install" do
    expect(resource.action).to eq(:install)
  end

  it "actions include :reinstall" do
    expect(resource.allowed_actions).to include(:reinstall)
  end

  it "#to_s includes user if provided" do
    resource.user("molly")
    expect(resource.to_s).to eq("rbenv_ruby[antruby] (molly)")
  end

  it "#to_s includes system label if user is not provided" do
    expect(resource.to_s).to eq("rbenv_ruby[antruby] (system)")
  end
end
