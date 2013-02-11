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

See the examples in the `examples/` directory for some more good ideas.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
