require 'cardlike'
require 'highline/import'

Cardlike.game do
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
  end

  players = []
  players << hand "Player 1"
  players << hand "Player 2"

  players.each do |player|
    7.times { the_deck("Go Fish").draw_into player }
  end

  current_player = players.first
  target_player = players.last
  if players.size > 2
    target_player = choose do |menu|
      menu.prompt "#{current_player.name}, who are you asking? "
      menu.choices(players.map { |p| p.name })
    end
  end
  asked_for = choose do |menu|
    menu.prompt "#{current_player.name}, what are you looking for? "
    menu.choices(current_player.map {|c| c.name })
  end

  another_turn = false
  if removed = target_player.remove_card_if { |c| c.value == asked_for.value }
    current_player << removed
    puts "Got one!"
    another_turn = true
  else
    puts "Go Fish!"
    the_deck("Go Fish").draw_into current_player
  end
  #FIXME: repeat if another_turn == true, else switch players

end
