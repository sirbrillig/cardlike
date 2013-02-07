require "cardlike/version"
require "cardlike/deck"
require "cardlike/card"
require "active_support/inflector"

module Cardlike
  def self.version
    "#{self} version #{VERSION}"
  end

  def self.deck(name, &block)
    @decks ||= {}
    d = Deck.new(name: name)
    d.instance_eval(&block) if block_given?
    @decks[name] = d
    d
  end

  def self.the_deck(name)
    @decks ||= {}
    @decks[name]
  end

  def self.card(name, &block)
    c = Card.new(name: name)
    c.instance_eval(&block) if block_given?
    c
  end

  def self.type_of_card(name, &block)
    klass = Class.new(Card)
    klass_name = name.to_s.camelize
    Object.const_set(klass_name, klass) if not Object.const_defined?(klass_name)
    c = Object.const_get(klass_name)
    c.class_eval(&block) if block_given?

    Deck.send(:define_method, "new_#{name.to_s.downcase.underscore}", lambda { |arg, &blk| card = c.create(arg, &blk); self << card; card })

    c
  end

end
