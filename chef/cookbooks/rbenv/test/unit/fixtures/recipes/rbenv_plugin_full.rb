rbenv_plugin "rbenv-coolness" do
  git_url "https://example.com/rbenv-coolness.git"
  git_ref "feature-branch"
  root_path "/tmp/rootness"
  user "sam"
  action :install
end
