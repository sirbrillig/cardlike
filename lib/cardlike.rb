require "cardlike/version"
require "cardlike/deck"
require "cardlike/card"
require "cardlike/hand"
require "cardlike/score"
require "cardlike/turn"
require "active_support/inflector"

module Cardlike
  def self.version
    "#{self} version #{VERSION}"
  end

  #
  # Optionally use this to wrap Cardlike DSL methods to avoid having to prefix
  # them with +Cardlike+. This is  mainly useful for large blocks.
  #
  #   Cardlike.game do
  #     type_of_card :playing_card { has :suit }
  #   end
  #
  # is the same as
  #
  #   Cardlike.type_of_card :playing_card { has :suit }
  #
  def self.game(&block)
    self.class_eval(&block)
  end

  #
  # Set up a new Deck with the given name. Returns the created Deck which can
  # also be accessed with +the_deck+. Within the block you may use the Deck DSL.
  #
  #   Cardlike.deck "Poker Deck" do
  #     include_card "King of Diamonds"
  #     include_card "Three of Clubs"
  #   end
  #
  def self.deck(name, &block)
    @decks ||= {}
    d = Deck.new(name: name)
    d.instance_eval(&block) if block_given?
    @decks[name] = d
    d
  end

  #
  # Set up a new Hand with the given name. Returns the created Hand which can
  # also be accessed with +the_deck+. Within the block you may use the Hand DSL.
  #
  #   Cardlike.hand "Poker Hand" do
  #     include_card "King of Diamonds"
  #     include_card "Three of Clubs"
  #   end
  #
  def self.hand(name, &block)
    @hands ||= {}
    d = Hand.new(name: name)
    d.instance_eval(&block) if block_given?
    @hands[name] = d
    d
  end

  #
  # Return a Deck created by the +deck+ method by +name+.
  #
  #   Cardlike.the_deck("Blackjack Deck").size # => 52
  #
  def self.the_deck(name)
    @decks ||= {}
    @decks[name]
  end

  #
  # Return a Hand created by the +hand+ method by +name+.
  #
  #   Cardlike.the_hand("Poker Hand").size # => 5
  #
  def self.the_hand(name)
    @hands ||= {}
    @hands[name]
  end

  # 
  # Return a Card created by the +card+ method. Also will return cards created
  # by the custom +new_+ card methods (see +type_of_card+).
  #
  #   Cardlike.the_card("Six of Diamonds").name # => "Six of Diamonds"
  #
  def self.the_card(name)
    @cards ||= {}
    @cards[name]
  end

  #
  # Create a new Card with the given name and block evaluated in the context of
  # the Card. Returns the Card (that can also be accessed with +the_card+). You
  # may use the Card DSL in the block.
  #
  #   Cardlike.card "Fire Monster"
  #
  def self.card(name, &block)
    c = Card.create(name, &block)
    @cards ||= {}
    @cards[name] = c
    c
  end

  #
  # Create a new subclass of Card with its own properties as defined in the
  # block. You may use the Card class DSL in the block. Automatically defines a
  # method for creating new objects of that class, prefixed by +new_+. For
  # example, a <tt>type_of_card :fun_card</tt> defines the method +new_fun_card+
  # (which operates like the +card+ method) that can be used in either a +deck+
  # block or directly.
  #   
  #   Cardlike.type_of_card :playing_card do
  #     has :value
  #     has :suit
  #   end
  #
  # You can then access the card with:
  #
  #   Cardlike.new_playing_card "Six of Spades" do
  #     value 6
  #     suit 'spades'
  #   end
  #
  # or:
  #
  #   Cardlike.deck "Poker Deck" do
  #     new_playing_card "Six of Spades" do
  #       value 6
  #       suit 'spades'
  #     end
  #   end
  #
  def self.type_of_card(name, &block)
    klass = Class.new(Card)
    klass_name = name.to_s.camelize
    name_underscored = name.to_s.downcase.underscore
    Object.const_set(klass_name, klass) if not Object.const_defined?(klass_name)
    c = Object.const_get(klass_name)
    c.class_eval(&block) if block_given?

    Deck.send(:define_method, "new_#{name_underscored}", lambda { |arg, &blk| card = c.create(arg, &blk); card.card_type = name_underscored.to_sym; self << card; card })
    self.class.send(:define_method, "new_#{name_underscored}", lambda { |arg, &blk| card = c.create(arg, &blk); card.card_type = name_underscored.to_sym; @cards ||= {}; @cards[arg] = card; card })

    c
  end

end
