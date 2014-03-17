require 'puppet/parser/functions'

module Puppet::Parser::Functions
  newfunction(:suffix_keys, :type => :rvalue, :doc => <<-EOS
Returns a copy of input hash where the keys have been appended to with the suffix.

*Examples*:

    $hash = suffix_keys({'a' => 'b'}, 'c')

Would return {'ac' => 'b'}

    EOS
  ) do |args|
    if args.size != 2
      raise(Puppet::ParseError, "suffix_keys(Hash, Suffix String): Wrong number of arguments " +
        "given (#{args.size} for 2)")
    end

    unless args[0].is_a? Hash
      raise(Puppet::ParseError,
            "suffix_keys(): expected a hash, got #{args[0]} type #{args[0].class} ")
    end

    args[0].inject({}) do |h, kv|
      k, v = kv
      h["#{k}#{args[1]}"] = v
      h
    end    
  end  
end
