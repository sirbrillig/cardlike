# Cardlike

A DSL to design and test card games.

## Installation

Add this line to your application's Gemfile:

    gem 'cardlike'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cardlike

Include the gem in your code to use it.

    require 'cardlike'

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
stored globally and can be accessed with `the_card` and the card's name (unless
they were created directly in a Deck).

    Cardlike.card "Draw one Play one" # => creates (and returns) a new Card object
    Cardlike.the_card "Draw one Play one" # => the Card object created above (NOT a copy)

A block passed to the `card` method will be executed in the new Card's context.
Card objects can have properties, but it's best to create a custom type of card
to do this.

    Cardlike.type_of_card :action_card do
      has :power_level
      has :color
      has :speed
    end

    Cardlike.new_action_card "Magic Spell" do
      power_level 5
      color :red
      speed :fast
    end # => new Card object (actually a new ActionCard object)

    Cardlike.the_card("Magic Spell")[:color] # => :red
    Cardlike.the_card("Magic Spell")[:power_level] # => 5
    Cardlike.the_card("Magic Spell").speed # => :fast (this style available after 0.0.2)

The `type_of_card` method creates a new subclass of Card. Use the `has` method in
a `card` block to add a property. A new card creation method is added to the DSL
with the type of card prefixed by `new_`. 

To assign a property to a new card in the card block, use a method of the same
name as the property. To retrieve that property, treat the card as a hash and
reference the property name as the key. As of version 0.0.2, you can also get
the property value by calling a getter method of the same name as the key.

If you'd like to know what kind of card you're dealing with, just ask it with
`card_type`.

    Cardlike.the_card("Magic Spell").card_type # => :action_card

### Creating Decks

But what you really want to do is create a Deck of cards.

    Cardlike.game do
      
      type_of_card :action_card do
        has :power_level
        has :cost
      end

      deck "Action Deck" do

        new_action_card "Magic Spell" do
          power_level 5
          cost 3
        end

        new_action_card "Subtle Strike" do
          power_level 2
          cost 2
        end

        new_action_card "Wide Swing" do
          power_level 1
          cost 1
        end

        3.times { copy_card "Magic Spell" }
        3.times { copy_card "Subtle Strike" }
        3.times { copy_card "Wide Swing" }

      end

    end

You can use the `deck` method to name a new deck and pass it a block which will
be evauluated in the context of the Deck. In this case, we put a bunch of `card`
creation methods in the block, or more specifically, `new_action_card` (the
method that was created by `type_of_card`). 

Cards defined within the `deck` method will automatically be added to the Deck.
You can also add cards by treating the Deck as an Array (which it is).

    Cardlike.game do
      type_of_card :action_card
      @card1 = new_action_card "Magic Spell"
      @deck = deck "Action Deck"

      @deck << @card1
    end

Decks can be accessed using `the_deck` method, which takes the name of a Deck.
The cards within are inside an Array, so most Array methods will work
(particularly `Deck#shuffle!`).

    Cardlike.game do
      ...
      the_deck("Action Deck").shuffle!
      the_deck("Action Deck").first.name # => could be "Magic Spell"
    end

### Drawing into Hands

Often you probably want to draw the top card of the deck. Cardlike Decks have a
`draw` method and a `draw_into` method. Both remove and return the top Card from
that Deck. `draw_into` takes an additional argument which should be an Array,
Deck, or Hand (or something that responds to `<<`).

A Hand is a subclass of a Deck with some additional methods. Creating a Hand is
easiest with the `hand` method (which works like the `Deck` method).

    Cardlike.game do
      type_of_card :action_card
      @card1 = new_action_card "Magic Spell"
      @deck = deck "Action Deck" do
        2.times { copy_card "Magic Spell" }
      end

      the_deck("Action Deck").draw # => <Card, :name => 'Magic Spell'>

      @player1 = hand "Player 1"

      the_deck("Action Deck").draw_into @player1 # => <Card, :name => 'Magic Spell'>
    end

Hands can be accessed by `the_hand`, just like the other Cardlike objects.

    Cardlike.game do
      ...
      hand "Player 1"
      the_deck("Action Deck").draw_into the_hand("Player 1")
      the_hand("Player 1").size # => 1
    end

### Defining a Turn

As most games have turns, you can define a block of code as a turn using the
`define_turn` method and then call it using `begin_new_turn`. Any number of
arguments can be passed to the block.

    Cardlike.game do
      ...

      define_turn do |current_hand|
        the_deck("Action Deck").draw_into current_hand # Draw a card
        puts "#{current_hand.name}'s Hand: #{current_hand}"
      end

      hands = []
      hands << hand "Player 2"
      hands << hand "Player 1"

      begin
        hands.rotate!
        begin_new_turn(hands.first)
      end while victory == false
    end

### Keeping Score

Chances are there's scoring in your game too. You can use the `score` method to
add a score to a particular key. The key can be anything, so players can have
several scores or the game could keep score of several objects at once.

You can retrieve the score using `the_score` followed by the key or get a Hash
of all the scores with `scores`. 

If you need to decrement the score or set it to a particular number, use
`set_score`.

    Cardlike.game do
      ...
      score "Player 1" # sets the score to 1
      score "Player 2" # sets the score to 1
      score "Player 1" # sets the score to 2

      the_score "Player 1" # => 2

      scores # => {"Player 1" => 2, "Player 2" => 1}

      set_score "Player 2", 5

      scores # => {"Player 1" => 2, "Player 2" => 5}

    end

### Examples

See the examples in the `examples/` directory for some more good ideas.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
