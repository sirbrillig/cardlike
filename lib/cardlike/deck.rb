#
# Represents a game deck. Best used with the Card and Deck DSL. See Cardlike.
#
class Cardlike::Deck < Array
  attr_accessor :name

  #
  # Create a new Deck. Options should always include +:name+ and may optionally
  # include +:cards+, which is an array of Card objects (ideally) to keep in
  # this deck. It's better to use Cardlike.deck to create decks, though.
  #
  def initialize(options={})
    self.name = options[:name]
    options[:cards].each { |c| self << c } if options[:cards]
  end

  # 
  # Draw the top card from this deck and return it.
  #
  def draw
    self.pop
  end

  #
  # Shuffle this deck and return a copy Deck. Probably more useful is
  # Deck#shuffle!  which will shuffle this deck in place.
  #
  def shuffle
    self.dup.shuffle!
  end

  # 
  # Append an array (or Deck) of cards to this Deck.
  #
  def +(ary)
    ary.each { |a| self << a }
    self
  end

  #
  # DSL method to add a pre-defined card to this Deck. This inserts the unique
  # card into the deck. If you want to put a copy into the deck (or several
  # copies), use Deck#copy_card instead.
  #
  #   Cardlike.game do
  #     card "Super Strike"
  #
  #     deck "My Deck" do
  #       include_card "Super Strike"
  #     end
  #   end
  #
  def include_card(name)
    raise "Card '#{name}' not found." unless card = Cardlike.the_card(name)
    self << card
  end

  #
  # DSL method to add a duplicate of a pre-defined card to this Deck.
  #
  #   Cardlike.game do
  #     card "Super Strike"
  #
  #     deck "My Deck" do
  #       4.times { copy_card "Super Strike" }
  #     end
  #   end
  #
  def copy_card(name)
    raise "Card '#{name}' not found." unless card = Cardlike.the_card(name)
    copy = card.dup
    self << copy
  end

  # 
  # DSL method to create a new card inside this deck. Also check out the +new_+
  # methods created by Cardlike.type_of_card. This works just like Cardlike.card
  # except that it automatically adds the card to this deck.
  #
  #   Cardlike.deck "Options Deck" do
  #     card "Magic Spell"
  #     card "Arcane Mark"
  #     card "Simple Attack"
  #   end
  #
  def card(name, &block)
    c = Cardlike.card(name, &block)
    self << c
    c
  end

  # 
  # Like Deck#draw except that it draws a card and then adds it to a Deck or
  # Hand. Also returns the card drawn.
  #
  #   Cardlike.the_deck("Poker Deck").draw_into(Cardlike.the_hand("Player 1"))
  #
  def draw_into(deck)
    card = draw
    deck << card
    card
  end
end
