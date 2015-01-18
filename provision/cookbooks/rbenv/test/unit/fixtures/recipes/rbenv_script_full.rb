rbenv_script "all-the-things" do
  code    "rake doit:all"
  rbenv_version "thebest"
  user    "lockwood"
  group   "inventor"
  creates "/opt/success"
  cwd     "/usr/dir"
  path    ["/opt/bin"]
  returns [0, 255]
  timeout 600
  umask   0221
  environment("FRUIT" => "strawberry")
end
