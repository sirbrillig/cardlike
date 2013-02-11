require 'cardlike'
require 'highline/import'

Cardlike.game do
  puts "Setting up..."

  type_of_card :playing_card do
    has :face
    has :value
    has :suit
  end

  deck "Go Fish" do
    ['Spades', 'Clubs', 'Diamonds', 'Hearts'].each do |card_suit|
      ['Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Jack', 'Queen', 'King', 'Ace'].each_with_index do |name, index|
        new_playing_card("#{name} of #{card_suit}") do
          value index
          face name
          suit card_suit
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
    puts "#{target_player.name}, do you have any #{target_card[:face]}s?\n"

    another_turn = false
    removed = target_player.remove_card_if { |c| c[:value] == target_card[:value] }
    unless removed.empty?
      current_player += removed
      puts "Got one! Yes indeed, #{target_player.name} had #{removed.size} #{removed.first[:face]}#{removed.size == 1 ? '' : 's'}."
      puts "You get another turn."
      another_turn = true

      # Check for matches.
      matching_sets = current_player.group_by { |c| c[:value] }.select { |k, v| v.size >= 4 }
      matching_sets.each do |matching_value, cards|
        matching_card = cards.first
        puts "You have a matching set of #{matching_card[:face]}s!"
        current_player.remove_card_if { |c| c[:value] == matching_value }
        score current_player.name
      end

    else
      puts "Go Fish!\n"
      drawn = the_deck("Go Fish").draw_into current_player
      puts "You drew a #{drawn.name}."

      # Check for matches.
      matching_sets = current_player.group_by { |c| c[:value] }.select { |k, v| v.size >= 4 }
      matching_sets.each do |matching_value, cards|
        matching_card = cards.first
        puts "Good fortune! You have a matching set of #{matching_card[:face]}s!"
        puts "You get another turn."
        another_turn = true
        current_player.remove_card_if { |c| c[:value] == matching_value }
        score current_player.name
      end

    end

    another_turn
  end

  begin
    puts "\nBeginning a new turn!"

    begin
      another_turn = begin_new_turn 

      if the_deck("Go Fish").empty?
        puts "\nThe deck is empty!\n"
        break
      end
      break if current_player.empty?

    end while another_turn
    players.rotate!
    current_player = players.first

    if the_deck("Go Fish").empty?
      break
    end
    break if current_player.empty?

  end until players.any? { |p| p.size < 1 }

  puts "\n\nThe game has ended!"

  winner = scores.max_by { |p, s| s }.first
  puts "#{winner} is the winner!"

end
