require 'puppet/parser/functions'

module Puppet::Parser::Functions
  newfunction(:ensure_rbenv_dependency, :type => :statement, :doc => <<-EOS
Takes a list of packages and only installs them if they don't already exist.
    EOS
  ) do |arguments|

    if arguments.size != 1
      raise(Puppet::ParseError, "ensure_rbenv_dependency(): Wrong number of arguments " +
        "given (#{arguments.size} for 1)")
    end

    packages = Array(arguments[0])

    Puppet::Parser::Functions.function(:ensure_resource)
    packages.each do |package_name|
      if resource = findresource("Package[#{package_name}]")
        if resource['ensure'] == 'absent'
          Puppet.fail("ensure_rbenv_dependency: Package[#{package_name}] is defined as absent, must be present")
        end
      else
        function_ensure_resource(['package', package_name, {'ensure' => 'present' } ])
      end
    end
    
  end  
end
