require 'puppet'
require 'puppet/face'
require 'net/http'
require 'net/https'
require 'uri'

Puppet::Face.define(:github, '0.0.1') do
  summary "Manage Puppet modules located on GitHub"
  copyright "James Turnbull", 2011
  license   "Apache 2 license; see LICENSE"

  option "--user USER" do
    desc "The GitHub user"
  end

  option "--repo REPO" do
    desc "The GitHub repo containing the Puppet module"
  end

  option "--path PATH:PATH" do
    desc "A colon-separated list of paths to your modules"
  end

  option "--branch BRANCH" do
    desc "The branch of the module. Defaults to master"
  end

  action :install do
    summary "Install a Puppet module from GitHub"
    description <<-EOT
      Install a Puppet module from a GitHub repository. It
      connects to GitHub and installs the modules specified 
      into the Puppet module path.
    EOT

    when_invoked do |options|
      config(options)

      Puppet.notice "Installing Puppet module #{@module} from #{github_uri}"

      clone_module
      clear_existing_files
      move_module
    end
  end

  action :compare do
    summary "Compare a currently installed moduled to its current GitHub state"
    description <<-EOT
      Compare a currently installed Puppet module to its GitHub parent repository. It
      connects to GitHub and compares the SHA of an currently installed module to its
      parent and returns the diff.
    EOT

    when_invoked do |options|
      config(options)
      check_module
      get_sha
      compare_module
    end
  end

  def config(options)
    @user = options[:user]
    @repo = options[:repo]
    @branch = 'master' unless options.has_key?(:branch)
    path = Puppet.settings[:modulepath] unless options.has_key?(:path)
    @install_path = path.split(':')[0]
    @module = @repo.gsub(/[_-]?puppet[-_]?/, '').gsub(/[_-]?module[-_]?/, '')
  end

  def github_uri
    "git://github.com/#{@user}/#{@repo}.git"
  end

  def compare_uri
    "https://github.com/#{@user}/#{@repo}/compare/#{get_sha}...#{@branch}.diff"
  end

  def get_sha
    `cd #{module_path}; git rev-parse #{@branch}`.chomp
  end

  def module_path
    File.join(@install_path, @module)
  end

  def tmppath
    File.join(ENV['TMPDIR'] || "/tmp", "_tmp_puppet_#{@module}")
  end

  def move_module
    `mv #{tmppath} #{module_path}`
  end

  def clear_existing_files
    Puppet.notice "Removing pre-existing version of #{@module}"
    `rm -rf #{module_path}` if File.directory?(module_path)
  end

  def clone_module
    `rm -rf #{tmppath}` if File.exists?(tmppath)
    `git clone #{github_uri} #{tmppath}`
    `cd #{tmppath}; git checkout #{@branch}`
  end

  def check_module
    fail "There is no #{@module} module installed at #{@install_path}" unless File.exists?(module_path)
  end

  def compare_module
    Puppet.notice "Comparing local Puppet module #{@module} to #{github_uri}"
    uri = URI.parse(compare_uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.path)
    contents = http.request(request).body
    if contents.empty?
      Puppet.notice "Local Puppet module #{@module} is up to date with #{github_uri}"
    else
      Puppet.notice "Displaying diff of local and remote #{@module} modules - use puppet github install to update."
      puts contents
    end
  end
end
