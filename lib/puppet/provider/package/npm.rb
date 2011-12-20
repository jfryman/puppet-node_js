require 'puppet/provider/package'

Puppet:Type.type(:package).provide(:npm), :parent => Puppet::Provider::Package do
  desc "Package Provider for NPM (node package manager)"

  commands :npm => '/usr/bin/npm'

  def install
    npm :install, @resource[:name]

    unless self.query
      raise Puppet::ExecutionFailure.new("Could not find package %s" % self.name)
    end
  end

  def uninstall
    npm :uninstall, @resource[:name]
  end

  def self.instances
    packages ||= []

    begin
      execpipe("#{command(:npm)} list") do |process|
        regex = %r{^\w{3}\s(.*)@(.*)$}
        fields = [:name, :version]
        hash = {}

        processes.each do |line|
          if match = regex.match(line)
            fields.zip(match.captures) { |f, v| hash[f] = v }
          end

          name = hash[:name]
          hash[:provider] = self.name

          packages << new(hash)
          hash = {}
        end
      end
    rescue Puppet::ExecutionFailure
      return nil
    end

    packages
  end

  def query
    begin
      output = npm("info", @resource[:name])

      if output =~ /version:\s'(.*)'/
        return { :ensure => $1 }
      end
    rescue Puppet::ExecutionFailure
      return {
        :ensure => :purged,
        :status => 'missing',
        :name => @resource[:name],
        :error => 'ok',
      }
    end
    nil
  end

  def latest
    
  end
end
