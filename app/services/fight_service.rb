class FightService
  # state / class method /

  def initialize(first_fighter, second_fighter)
    #Create the fight
    @fight = Fight.create(red_fighter: first_fighter, blue_fighter: second_fighter)

    #keep tabs on the 2 fighter's health
    @players = {
      first_fighter.id => {
        health: first_fighter.stats[:health_point],
        damage: calculate_player_damage(first_fighter, second_fighter)
      },
      second_fighter.id => {
        health: second_fighter.stats[:health_point],
        damage: calculate_player_damage(second_fighter, first_fighter)
      }
    }

    # the fighter with the highest speed_attack will attack first here
    @player = first_fighter.stats[:gear_speed_attack] > second_fighter.stats[:gear_speed_attack] ? first_fighter : second_fighter
    @opponent = (@player == first_fighter) ? second_fighter : first_fighter

    # some stats for the fighters need reset : leveled_up?,  received_gear?, stats_up_hash(in case of level up), new_gear_stats_array
    reset_previous_stats_from_last_fight
  end

  def run
    # loop until one fighter is defeated
    until @players[@opponent.id][:health] <= 0
      # setup the fighter's damage in turns
      player_damage = @players[@player.id][:damage]
      remaining_health = [(@players[@opponent.id][:health] - player_damage), 0].max
      @players[@opponent.id][:health] = remaining_health
      #turns keep track of the fight for the view to show
      turn_description = "#{@player.name} attacks, #{@opponent.name} loses #{player_damage}❤️, "
      if @players[@opponent.id][:health].zero?
        turn_description += "#{@opponent.name} dies horribly."
      else
        turn_description += "#{@players[@opponent.id][:health]}Hp left for #{@opponent.name}."
        # switch the players each turn to attack
        switch_player
      end
      @fight.turns << turn_description
    end
    #Setup the winner and the loser of the fight
    win_declaration
    #return the fight to the controller
    @fight
  end

  def win_declaration
    @fight.winner = @player.name
    @fight.loser = @opponent.name
    FighterService.win_battle(@player, @opponent)
    FighterService.lost_battle(@opponent, @player)
    @opponent.save!
    @player.save!
    @fight.turns << "Congratulation, #{@fight.winner} wins!"
    @fight.save!
  end

  def switch_player
    temporary_slot = @player
    @player = @opponent
    @opponent = temporary_slot
  end

  def reset_previous_stats_from_last_fight
    @player.stats_up_hash = { hp: 0,
                              attack: 0,
                              defence: 0,
                              speed_attack: 0
                            }
    @player.new_gear_stats_array = []
    @player.reset_received_gear
    @player.reset_leveled_up

    @opponent.stats_up_hash = {hp: 0,
                              attack: 0,
                              defence: 0,
                              speed_attack: 0
                            }
    @opponent.new_gear_stats_array = []
    @opponent.reset_received_gear
    @opponent.reset_leveled_up
  end

  def calculate_player_damage(player, opponent)
    # We lock the speed to be minimum 1
    ratio = [(player.stats[:gear_speed_attack] / opponent.stats[:gear_speed_attack].to_f), 1].max
    damage = ((player.stats[:gear_attack] - opponent.stats[:gear_defence]) * ratio).floor
    # We lock the damage to be minimum 1
    [damage, 1].max
  end
end
