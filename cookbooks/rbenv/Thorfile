# encoding: utf-8

require 'thor/foodcritic'
require 'berkshelf/thor'

class Default < Thor
  attr_reader :cookbook_name
  attr_reader :cookbook_category

  def initialize(*args)
    @cookbook_name = "rbenv"
    @cookbook_category = "Programming Languages"
    super(*args)
  end

  class_option :verbose,
    :type => :boolean,
    :aliases => "-v",
    :default => false

  method_option :knife_config,
    :type => :string,
    :aliases => "-c",
    :desc => "Path to your knife configuration file",
    :default => "~/.chef/knife.rb"
  desc "release", "Create a tag from the version specific in the metadata.rb and push to the community site"
  def release
    unless clean?
      say "There are files that need to be committed first.", :red
      exit 1
    end

    invoke :'foodcritic:lint'

    tag_version { publish_cookbook(options) }
  end

  private

    def clean?
      sh_with_excode("git diff --exit-code")[1] == 0
    end

    def current_version
      Berkshelf::CachedCookbook.from_path(source_root).version
    end

    def publish_cookbook(options)
      cmd = "knife cookbook site share #{cookbook_name} \"#{cookbook_category}\" -o #{source_root.join("..")} -c #{options[:knife_config]}"
      cmd << " -V" if options[:verbose]
      sh cmd
    end

    def tag_version
      sh "git tag -a -m \"Version #{current_version}\" #{current_version}"
      say "Tagged: #{current_version}", :green
      yield if block_given?
      sh "git push --tags"
    rescue => e
      say "Untagging: #{current_version} due to error", :red
      sh_with_excode "git tag -d #{current_version}"
      say e, :red
      exit 1
    end

    def source_root
      Pathname.new File.dirname(File.expand_path(__FILE__))
    end

    def sh(cmd, dir = source_root, &block)
      out, code = sh_with_excode(cmd, dir, &block)
      code == 0 ? out : raise(out.empty? ? "Running `#{cmd}` failed. Run this command directly for more detailed output." : out)
    end

    def sh_with_excode(cmd, dir = source_root, &block)
      cmd << " 2>&1"
      outbuf = ''

      Dir.chdir(dir) {
        outbuf = `#{cmd}`
        if $? == 0
          block.call(outbuf) if block
        end
      }

      [ outbuf, $? ]
    end
end

