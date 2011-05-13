require 'puppet/face'

Puppet::Face.define(:github, '0.0.1') do
  summary "Manage Puppet modules located on GitHub"
  copyright "James Turnbull", 2011
  license   "Apache 2 license; see LICENSE"

  option "--ssh" do
    desc "Use SSH to connect to GitHub"
  end

  option "--github_user USER" do
    desc "The GitHub user"
  end

  option "--github_repo REPO" do
    desc "The GitHub repo containing the Puppet module"
  end

  option "--module_path PATH:PATH" do
    desc "A colon-separated list of paths to your modules"
    before_action do |action, args, options|
      unless options[:module_path]
        options[:module_path] = Puppet.settings[:modulepath]
      end
    end
  end

  option "--branch BRANCH" do
    desc "The branch of the module. Defaults to master"
    before_action do |action, args, options|
      #unless options[:branch]
    end
  end

  action :install do
    summary "Install a Puppet module from GitHub"
    description <<-EOT
      Install a Puppet module from a GitHub repository. It
      connections to GitHub and installs the modules specified 
      into the Puppet module path.
    EOT

    when_invoked do |options|
      @user = options[:github_user]
      @repo = options[:github_repo]
      @branch = options[:branch]
      @module_path = options[:module_path]
      @install_path = @module_path.first
      @module = @repo.gsub(/[_-]?puppet[-_]?/, '').gsub(/[_-]?module[-_]?/, '')

      Puppet.notice "Installing Puppet module #{@module} from #{github_uri}"

      clone_module
      clear_existing_files(File.join(@install_path, @module))
      move_module
    end
  end

  def github_uri
    if @ssh || @user == ENV['USER']
      "git@github.com:#{@user}/#{@repo}.git"
    else
      "git://github.com/#{@user}/#{@repo}.git"
    end
  end

  def temp_clone_path
    "_tmp_puppet_#{@module}"
  end

  def tmpdir
    ENV['TMPDIR']
  end

  def move_module
    system "mv #{temp_clone_path} #{File.join(@install_path, @module)}"
  end

  def clear_existing_files(module_path)
    Puppet.notice "Removing pre-existing version."
    system "rm -r #{module_path}" if File.directory?(module_path)
  end

  def clone_module
    system "rm -rf #{temp_clone_path}" if File.exists?(File.join(tmpdir, temp_clone_path))
    system "git clone #{github_uri} #{temp_clone_path}"
    system "git checkout #{@branch}"
    system "rm -rf .git"
  end
end
