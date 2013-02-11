# Cardlike

A DSL to design and test card games.

## Installation

Add this line to your application's Gemfile:

    gem 'cardlike'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cardlike

## Summary

Cardlike provides a [DSL](http://en.wikipedia.org/wiki/Domain-specific_language)
for creating a card game. It's a layer of abstraction for making Cards (with
various properties), putting them into Decks, dealing them into Hands, and then
taking turns while keeping a running score. 

Cardlike is agnostic about what kind of game you want to create (it may not have
turns or a score) and how you want to interact with the game. Here's a few
possibilities for how you could use it:

* Write tests for a physical card game to see if it will work.
* Write a text-based card game.
* Use as a backend for a web card game (backbone.js, anyone?).
* Use as a backend for a native app card game.

## Usage

There are various ways to use the methods in Cardlike. Probably the easiest is
to define your whole game in a `Cardlike.game` block.

    Cardlike.game do
      card "Ace of Diamonds"
      card "Ace of Hearts"
      card "Ace of Spades"
      card "Ace of Clubs"

      deck "My Deck" do
        copy_card "Ace of Diamonds"
        copy_card "Ace of Hearts"
        copy_card "Ace of Clubs"
        copy_card "Ace of Spades"
      end

      the_deck("My Deck").shuffle!

      hand "Player 1"

      puts "Find the Ace of Spades!"

      the_deck("My Deck").draw_into(the_hand("Player 1"))

      if the_hand("Player 1").first.name == "Ace of Spades"
        puts "Congratulations, you win!"
      else
        puts "Oh, well, try again."
      end
    end

You can also prefix the class methods with Cardlike.

    Cardlike.type_of_card :playing_card do
      has :suit
    end
    
    Cardlike.new_playing_card "Six of Spades" do
      suit 'spades'
    end

    @deck = Cardlike.deck "My Deck" do
      include_card "Six of Spades"
    end

    puts "Drawing #{@deck.draw}" # @deck.draw == Cardlike.the_deck("My Deck").draw

### Creating Cards

The `card` method can be used to create a new Card object. Created cards are
stored globally and can be accessed with `the_card` and the card's name.

    Cardlike.card "Draw one Play one" # => creates (and returns) a new Card object
    Cardlike.the_card "Draw one Play one" # => the Card object created above (NOT a copy)

A block passed to the `card` method will be executed in the new Card's context.
Card objects can have properties, but it's best to create a custom type of card
to do this.

    Cardlike.type_of_card :action_card do
      has :power_level
      has :color
    end

    Cardlike.new_action_card "Magic Spell" do
      power_level 5
      color :red
    end # => new Card object (actually a new ActionCard object)

    Cardlike.the_card("Magic Spell")[:color] # => :red
    Cardlike.the_card("Magic Spell")[:power_level] # => 5

The `type_of_card` method creates a new subclass of Card. Use the `has` method in
a `card` block to add a property. A new card creation method is added to the DSL
with the type of card prefixed by `new_`. 

To assign a property to a new card in the card block, use a method of the same
name as the property. To retrieve that property, treat the card as a hash and
reference the property name as the key.

### Creating Decks

TODO

### Drawing into Hands

TODO

### Defining a Turn

TODO

### Keeping Score

TODO

### Examples

See the examples in the `examples/` directory for some more good ideas.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
