require_relative "../spec_helper"
load_lw_resource("rbenv", "script")

describe Chef::Resource::RbenvScript do

  let(:resource) { described_class.new("gogo") }

  it "sets the default attribute to name" do
    expect(resource.name).to eq("gogo")
  end

  it "attribute rbenv_version defaults to nil" do
    expect(resource.rbenv_version).to be_nil
  end

  it "attribute rbenv_version takes a String value" do
    resource.rbenv_version("bunnyruby")
    expect(resource.rbenv_version).to eq("bunnyruby")
  end

  it "attribute root_path defaults to nil" do
    expect(resource.root_path).to be_nil
  end

  it "attribute root_path takes a String value" do
    resource.root_path("/yep")
    expect(resource.root_path).to eq("/yep")
  end

  it "attribute code defaults to nil" do
    expect(resource.code).to be_nil
  end

  it "attribute code takes a String value" do
    resource.code("echo hi")
    expect(resource.code).to eq("echo hi")
  end

  it "attribute creates defaults to nil" do
    expect(resource.creates).to be_nil
  end

  it "attribute creates takes a String value" do
    resource.creates("/tmp/thefile")
    expect(resource.creates).to eq("/tmp/thefile")
  end

  it "attribute cwd defaults to nil" do
    expect(resource.cwd).to be_nil
  end

  it "attribute cwd takes a String value" do
    resource.cwd("/root")
    expect(resource.cwd).to eq("/root")
  end

  it "attribute environment defaults to nil" do
    expect(resource.environment).to be_nil
  end

  it "attribute environment takes a Hash value" do
    resource.environment({ "BEANS" => "pinto" })
    expect(resource.environment).to eq({ "BEANS" => "pinto" })
  end

  it "attribute group defaults to nil" do
    expect(resource.group).to be_nil
  end

  it "attribute group takes a String value" do
    resource.group("wheelers")
    expect(resource.group).to eq("wheelers")
  end

  it "attribute path defaults to nil" do
    expect(resource.path).to be_nil
  end

  it "attribute path takes an Array value" do
    resource.path(["/tmp/pathpath"])
    expect(resource.path).to eq(["/tmp/pathpath"])
  end

  it "attribute returns defaults to 0" do
    expect(resource.returns).to eq([0])
  end

  it "attribute returns takes an Array value" do
    resource.returns([0, 127, 255])
    expect(resource.returns).to eq([0, 127, 255])
  end

  it "attribute timeout defaults to nil" do
    expect(resource.timeout).to be_nil
  end

  it "attribute timeout takes an Integer value" do
    resource.timeout(123)
    expect(resource.timeout).to eq(123)
  end

  it "attribute user defaults to nil" do
    expect(resource.user).to be_nil
  end

  it "attribute user takes a String value" do
    resource.user("eric")
    expect(resource.user).to eq("eric")
  end

  it "attribute umask defaults to nil" do
    expect(resource.umask).to be_nil
  end

  it "attribute umask takes a String value" do
    resource.umask("0777")
    expect(resource.umask).to eq("0777")
  end

  it "attribute umask takes an Integer value" do
    resource.umask(0640)
    expect(resource.umask).to eq(0640)
  end

  it "action defaults to :run" do
    expect(resource.action).to eq(:run)
  end
end
