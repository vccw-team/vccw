require_relative "../spec_helper"

describe "rbenv_rehash provider" do

  let(:runner)    { ChefSpec::Runner.new(step_into: ["rbenv_rehash"]) }
  let(:node)      { runner.node}

  context "with a fully configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_rehash_full") }

    it "runs an rbenv_script" do
      expect(chef_run).to run_rbenv_script("rbenv rehash (jdoe)").with(
        code:       "rbenv rehash",
        user:       "jdoe",
        root_path:  "/rooty"
      )
    end
  end

  context "with a defaults configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_rehash_defaults") }

    it "runs an rbenv_script" do
      expect(chef_run).to run_rbenv_script("rbenv rehash (system)").with(
        code: "rbenv rehash"
      )
    end
  end
end
