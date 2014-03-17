require 'puppet/parser/functions'

module Puppet::Parser::Functions
  newfunction(:suffix_keys, :type => :rvalue, :doc => "Appends a suffix to each key of a Hash.") do |arguments|

    if arguments.size != 2
      raise(Puppet::ParseError, "suffix_keys(Hash, Suffix String): Wrong number of arguments " +
        "given (#{arguments.size} for 2)")
    end

    hash = arguments.unshift
    suff = arguments.unshift

    hash.inject({}) do |h, kv|
      k, v = kv
      h["#{k}#{suff}"] = v
      h
    end    
  end  
end
