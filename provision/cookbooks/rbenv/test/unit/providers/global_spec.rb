require_relative "../spec_helper"

describe "rbenv_global provider" do

  let(:runner)    { ChefSpec::Runner.new(step_into: ["rbenv_global"]) }
  let(:node)      { runner.node}

  context "with a fully configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_global_full") }

    it "runs an rbenv_script" do
      expect(chef_run).to run_rbenv_script("rbenv global 9.1.2 (claire)").with(
        code:       "rbenv global 9.1.2",
        user:       "claire",
        root_path:  "/mnt/roobies"
      )
    end
  end

  context "with a default configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_global_defaults") }

    it "runs an rbenv_script" do
      expect(chef_run).to run_rbenv_script("rbenv global 1.6.5 (system)").with(
        code:       "rbenv global 1.6.5",
        user:       nil,
        root_path:  nil
      )
    end
  end
end
