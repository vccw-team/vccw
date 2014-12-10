guard :rspec, spec_paths: ["test/unit"] do
  watch(%r{^test/unit/.+_spec\.rb$})
  watch(%r{^(libraries|providers|recipes|resources)/(.+)\.rb$}) { |m| "test/unit/#{m[1]}/#{m[2]}_spec.rb" }
  watch("test/unit/spec_helper.rb")  { "test/unit" }
end
