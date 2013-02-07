require "cardlike/version"
require "cardlike/deck"
require "cardlike/card"

module Cardlike
  def self.version
    "#{self} version #{VERSION}"
  end

  def self.card(name, &block)
    #klass = Class.new(Card)
    #constant_name = name.gsub(/\s+/, '_')
    #Object.const_set(constant_name, klass) if not Object.const_defined?(constant_name)
    #c = Object.const_get(constant_name).new
    c = Card.new(name: name)
    #c.name = name
    #c.class.class_eval(&block) if block_given?
    c.instance_eval(&block) if block_given?
    c
  end

end
