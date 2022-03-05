class FightService
  # state / class method /

  def initialize(first_fighter, second_fighter)
    @fight = Fight.create!(red_fighter: first_fighter, blue_fighter: second_fighter)

    @players_health = {
      first_fighter.id => first_fighter.stats[:health_point],
      second_fighter.id => second_fighter.stats[:health_point]
    }

    @player = first_fighter.stats[:gear_speed_attack] > second_fighter.stats[:gear_speed_attack] ? first_fighter : second_fighter
    @opponent = (@player == first_fighter) ? second_fighter : first_fighter
    reset_previous_stats_from_last_fight
  end

  def run
    while @players_health[@player.id] >= 0
      damage = @player.stats[:gear_attack] - @opponent.stats[:gear_defence]
      if @player.stats[:gear_speed_attack] > @opponent.stats[:gear_speed_attack]
        ratio = (@player.stats[:gear_speed_attack] / @opponent.stats[:gear_speed_attack].to_f)
        damage = (@player.stats[:gear_attack] * ratio).floor - @opponent.stats[:gear_defence]
      end
      damage = 1 if damage <= 1
      if @players_health[@opponent.id] - damage <= 0
        damage = damage - @players_health[@opponent.id] == 0 ? damage : damage - @players_health[@opponent.id]
        @players_health[@opponent.id] -= damage
        @fight.turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}❤️,
        #{@opponent.name} dies horribly."
        break
      end
      @players_health[@opponent.id] -= damage
      @fight.turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}❤️,
       #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."
      switch_player
    end
    win_declaration
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
