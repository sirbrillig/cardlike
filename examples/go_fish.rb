require 'cardlike'
require 'highline/import'

Cardlike.game do
  puts "Setting up..."

  type_of_card :playing_card do
    has :value
  end

  deck "Go Fish" do
    ['Spades', 'Clubs', 'Diamonds', 'Hearts'].each do |suit|
      ['Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Jack', 'Queen', 'King', 'Ace'].each_with_index do |name, index|
        new_playing_card("#{name} of #{suit}") do
          value index
        end
      end
    end

    shuffle!
  end
  
  players = []
  players << hand("Player 1")
  players << hand("Player 2")

  players.each do |player|
    7.times { the_deck("Go Fish").draw_into player }
  end

  current_player = players.first

  define_turn do
    target_player = players.last
    if players.size > 2
      target_name = choose do |menu|
        menu.prompt = "#{current_player.name}, who are you asking? "
        menu.choices(*players.map { |p| p.name })
      end
      target_player = players.select { |p| p.name == target_name }.first
    end

    target_card_name = choose do |menu|
      menu.prompt = "#{current_player.name}, what are you looking for? "
      menu.choices(*current_player.map {|c| c.name })
    end
    target_card = current_player.select { |c| c.name == target_card_name }.first

    another_turn = false
    if removed = target_player.remove_card_if { |c| c[:value] == target_card[:value] }
      current_player << removed
      puts "Got one! Yes indeed, #{target_player.name} had a #{removed.name}."
      puts "You get another turn."
      another_turn = true

      matching_sets = current_player.group_by { |c| c[:value] }.select { |k, v| v.size >= 4 }
      matching_sets.each_key do |value|
        # we will assume that you can only get a match from a card you just
        # collected.
        puts "You have a matching set of #{removed.name}!"
        current_player.remove_card_if { |c| c[:value] == value }
        score current_player.name
      end
    else
      puts "Go Fish!"
      the_deck("Go Fish").draw_into current_player
      # FIXME: check for matches here too.
    end
    # FIXME: check for empty deck.
    another_turn
  end

  begin
    puts "Beginning a new turn!"

    begin
      another_turn = begin_new_turn 
    end while another_turn
    players.rotate!
    current_player = players.first
  end until players.any? { |p| p.size < 1 }
  puts "The game has ended!"

  winner = scores.max_by { |p, s| s }.first
  puts "#{winner.name} is the winner!"

end
