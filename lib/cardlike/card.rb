#
# Represents a game card. Best used with the Card and Deck DSL. See Cardlike.
#
class Cardlike::Card
  attr_accessor :name

  attr_reader :card_type

  attr_accessor :attachments

  #
  # Create an instance of a Card. Arguments are a hash that should include
  # +:name+ at a minimum.  Perhaps a better idea is to use Card.create or
  # Cardlike.card. Also see Cardlike.type_of_card.
  #
  def initialize(options={})
    self.name = options[:name]
    @card_type = options[:card_type] || nil
    @properties = {}
    @attachments = []
  end

  def card_type=(type)
    raise "Cannot re-set type after it has been set." if @card_type
    @card_type = type
  end

  # 
  # Factory method to create an instance of a Card. This sets the name of the
  # card and its properties using the Card DSL in the corresponding block. You
  # can also use Cardlike.card, which does the same thing. Probably more useful
  # is to create custom card types using Cardlike.type_of_card and create them
  # using the +new_+ methods.
  #
  #   Card.create "Big Monster"
  #
  # Preferred over Card.new.
  #
  def self.create(name, &block)
    c = self.new(name: name)
    c.instance_eval(&block) if block_given?
    c
  end

  # 
  # Return custom properties of this Card. Custom properties can be set using
  # the Card.has method, ideally inside a Cardlike.type_of_card block.
  #
  #   @king_of_diamonds[:suit] # => 'Diamonds'
  #
  def [](prop)
    @properties[prop]
  end

  #
  # Class DSL method for setting custom properties for a Card that include a
  # block. See Cardlike.type_of_card.
  #
  def self.has_block(prop)
    define_method(prop, lambda { |&block| return @properties[prop] unless block; raise "Cards are immutable." if @properties.has_key? prop; @properties[prop] = block })
  end

  #
  # Class DSL method for setting custom properties for a Card. See
  # Cardlike.type_of_card.
  #
  def self.has(prop)
    define_method(prop, lambda { |arg=nil| return @properties[prop] unless arg; raise "Cards are immutable." if @properties.has_key? prop; @properties[prop] = arg })
  end

  #
  # Attach something (often another card) to this card. It can be retreieved
  # using the +attachments+ array.
  #
  def attach(item)
    @attachments << item
  end

  def to_s
    t = []
    t << "Name: #{name}"
    @properties.each { |p,v| t << "#{p}: #{v}" unless v.nil? or v.is_a? Proc } 
    "[ "+t.join("; ")+" ]"
  end

end
