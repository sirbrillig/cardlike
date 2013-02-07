require "cardlike/version"
require "cardlike/deck"
require "cardlike/card"

module Cardlike
  def self.version
    "#{self} version #{VERSION}"
  end

  def self.card(name, &block)
    c = Card.new(name: name)
    c.instance_eval(&block) if block_given?
    c
  end

  def self.type_of_card(name, &block)
    klass = Class.new(Card)
    klass_name = name.gsub(/\s+/, '')
    Object.const_set(klass_name, klass) if not Object.const_defined?(klass_name)
    c = Object.const_get(klass_name)
    c.class_eval(&block) if block_given?
    c
  end

end
