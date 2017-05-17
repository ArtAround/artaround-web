require 'cgi'

class ParamsCleaner
  def self.clean params={}
    params.each do |k, v|
      params[k] = unescape v
    end
  end

  def self.unescape obj
    return unescape_hash(obj) if obj.respond_to? :keys
    return unescape_array(obj) if obj.respond_to? :map
    return obj if obj.is_a? Numeric
    CGI::unescape obj
  end

  def self.unescape_hash hash
    hash.each do |k, v|
      hash[k] = unescape v
    end
  end

  def self.unescape_array array
    array.map{|i| unescape i}
  end
end
