class FightService
  # state / class method /

  def initialize(first_fighter, second_fighter)
    #Create the fight
    @fight = Fight.create(red_fighter: first_fighter, blue_fighter: second_fighter)

    #keep tabs on the 2 fighter's health
    @players_health = {
      first_fighter.id => first_fighter.stats[:health_point],
      second_fighter.id => second_fighter.stats[:health_point]
    }

    # the fastest player will attack first here
    @player = first_fighter.stats[:gear_speed_attack] > second_fighter.stats[:gear_speed_attack] ? first_fighter : second_fighter
    @opponent = (@player == first_fighter) ? second_fighter : first_fighter

    # some stats for the fighters need reset : leveled_up?,  received_gear?, stats_up_hash(in case of level up), new_gear_stats_array
    reset_previous_stats_from_last_fight
  end

  def run
    # loop until one fighter is defeated
    until @players_health[@player.id] <= 0
      # setup the fighter's damage in turns
      damage = @player.stats[:gear_attack] - @opponent.stats[:gear_defence]
      if @player.stats[:gear_speed_attack] > @opponent.stats[:gear_speed_attack]
        #Only if the player's speed attack is higher than the opponent's it gets a bonus for the attack
        ratio = (@player.stats[:gear_speed_attack] / @opponent.stats[:gear_speed_attack].to_f)
        damage = ((@player.stats[:gear_attack] - @opponent.stats[:gear_defence]) * ratio).floor
      end
      # the damage should not be equal to 0 or less
      damage = 1 if damage <= 1
      if @players_health[@opponent.id] - damage <= 0
        # if opponent dies this turn inflict only the remaining healthpoint as damage
        damage = damage - @players_health[@opponent.id] == 0 ? damage : damage - @players_health[@opponent.id]
        @players_health[@opponent.id] -= damage
        #turns keep track of the fight for the view to show
        @fight.turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}❤️,
        #{@opponent.name} dies horribly."
        break
      end
      @players_health[@opponent.id] -= damage
      #turns keeps track of the fight's details for the view to show
      @fight.turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}❤️,
       #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."
      # switch the players each turn to attack
      switch_player
    end
    #Setup the winner and the loser of the fight
    win_declaration
    #return the fight to the controller
    @fight
  end

  def win_declaration
    @fight.winner = @player.name
    @fight.loser = @opponent.name
    @player.win_battle(@opponent.level)
    @opponent.lost_battle(@player.level)
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
end
