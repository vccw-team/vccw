require_relative "../spec_helper"

describe "rbenv_script provider" do

  let(:runner)    { ChefSpec::Runner.new(step_into: ["rbenv_script"]) }
  let(:node)      { runner.node}

  context "with a fully configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_script_full") }

    before do
      user = double(dir: "/mnt/lockwood")
      allow(Etc).to receive(:getpwnam).with("lockwood") { user }
    end

    it "runs a script" do
      code = <<-CODE.gsub(/^\s+/, '')
        export RBENV_ROOT="/mnt/lockwood/.rbenv"
        export PATH="${RBENV_ROOT}/bin:$PATH"
        eval "$(rbenv init -)"
        export RBENV_VERSION="thebest"
        rake doit:all
      CODE
      environment = {
        "RBENV_ROOT"  => "/mnt/lockwood/.rbenv",
        "USER"        => "lockwood",
        "HOME"        => "/mnt/lockwood",
        "FRUIT"       => "strawberry"
      }

      expect(chef_run).to run_script("all-the-things").with(
        interpreter:    "bash",
        code:           code,
        user:           "lockwood",
        group:          "inventor",
        creates:        "/opt/success",
        cwd:            "/usr/dir",
        path:           ["/opt/bin"],
        returns:        [0, 255],
        timeout:        600,
        umask:          0221,
        environment:    environment
      )
    end
  end

  context "with a default configured resource" do

    let(:chef_run)  { runner.converge("fixtures::rbenv_script_defaults") }

    before do
      node.set["rbenv"]["root_path"] = "/zz"
    end

    it "runs a script" do
      code = <<-CODE.gsub(/^\s+/, '')
        export RBENV_ROOT="/zz"
        export PATH="${RBENV_ROOT}/bin:$PATH"
        eval "$(rbenv init -)"
        rake nadda
      CODE
      environment = { "RBENV_ROOT"  => "/zz" }

      expect(chef_run).to run_script("not-much").with(
        interpreter:  "bash",
        code:         code,
        user:         nil,
        group:        nil,
        creates:      nil,
        cwd:          nil,
        path:         nil,
        returns:      [0],
        timeout:      nil,
        umask:        nil,
        environment:  environment
      )
    end
  end
end
