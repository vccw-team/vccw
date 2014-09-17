setup() {
  export HOME=/root
  export PATH="$ruby_root/bin:$PATH"
  eval `$ruby_root/bin/ruby - <<EOF
require 'rubygems'
puts "export RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
puts "export RUBY_VERSION=#{RUBY_VERSION};"
puts "export GEM_ROOT=#{Gem.default_dir.inspect};"
EOF`
  export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
  export GEM_PATH="$GEM_HOME:$GEM_ROOT"
  export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$PATH"
}

run_openssl_test() {
  local script="puts OpenSSL::PKey::RSA.new(512).to_pem"

  run ruby -ropenssl -e "$script"
  [ $status -eq 0 ]
}

run_nokogiri_install_test() {
  run gem install nokogiri --no-ri --no-rdoc
  [ $status -eq 0 ]
}

run_nokogiri_openssl_test() {
  local https_url="https://google.com"
  local script="puts Nokogiri::HTML(open('$https_url')).css('input')"

  run ruby -rrubygems -ropen-uri -rnokogiri -e "$script"
  [ $status -eq 0 ]
}
