require_relative "../spec_helper"

describe "rbenv_plugin provider" do

  let(:runner)    { ChefSpec::Runner.new(step_into: ["rbenv_plugin"]) }
  let(:node)      { runner.node}

  context "with a fully configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_plugin_full") }

    it "creates the parent directory for plugins" do
      expect(chef_run).to create_directory("/tmp/rootness/plugins").with(
        owner: "sam",
        mode: 00755
      )
    end

    it "downloads the plugin with git" do
      expect(chef_run).to sync_git("Install rbenv-coolness plugin").with(
        destination: "/tmp/rootness/plugins/rbenv-coolness",
        repository: "https://example.com/rbenv-coolness.git",
        reference: "feature-branch",
        user: "sam"
      )
    end
  end

  context "with a minimally configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_plugin_defaults") }

    before { node.set["rbenv"]["root_path"] = "/ohyeah" }

    it "creates the parent directory for plugins" do
      expect(chef_run).to create_directory("/ohyeah/plugins").with(
        owner: "root",
        mode: 00755
      )
    end

    it "downloads the plugin with git" do
      expect(chef_run).to sync_git("Install rbenv-root-default plugin").with(
        destination: "/ohyeah/plugins/rbenv-root-default",
        repository: "foo.git",
        reference: "master"
      )
    end
  end
end
