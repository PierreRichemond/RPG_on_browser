class FightService
  # state / class method /

  def initialize(first_fighter, second_fighter)
    @fight = Fight.create!(red_fighter: first_fighter, blue_fighter: second_fighter)

    @players_health = {
      first_fighter.id => first_fighter.stats[:health_point],
      second_fighter.id => second_fighter.stats[:health_point]
    }

    @player = first_fighter.stats[:gear_speed_attack] > second_fighter.stats[:gear_speed_attack] ? first_fighter : second_fighter
    @opponent = (@player == first_fighter) ? second_fighter  : first_fighter
  end

  def run
    @player.stats_up_hash = { hp: 0,
                              attack: 0,
                              defence: 0,
                              speed: 0
                            }
    @opponent.stats_up_hash = {hp: 0,
                              attack: 0,
                              defence: 0,
                              speed: 0
                            }
    @player.gear_stats_array = []
    @opponent.gear_stats_array = []

    while @players_health[@player.id] >= 0
      damage = @player.stats[:gear_attack] - @opponent.stats[:gear_defence]
      if @player.stats[:gear_speed_attack] > @opponent.stats[:gear_speed_attack]
        ratio = (@player.stats[:gear_speed_attack] / @opponent.stats[:gear_speed_attack]).floor
        damage = (@player.stats[:gear_attack] * ratio).floor - @opponent.stats[:gear_defence]
      end
      damage = 1 if damage <= 1
      @players_health[@opponent.id] = @players_health[@opponent.id] - damage
      if @players_health[@opponent.id] <= 0
        @fight.turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}❤️, #{@opponent.name}."
        switch_player
        break
      end
      @fight.turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}❤️, #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."
      switch_player
    end
    win_declaration
    @fight
  end

  def win_declaration
    @fight.winner = @opponent.name
    @fight.loser = @player.name
    @opponent.win_battle(@player.level)
    @player.lost_battle(@opponent.level)
    @player.save!
    @opponent.save!
    @fight.turns << "Congratulation, #{@fight.winner} wins!"
    @fight.save!
  end

  def switch_player
    temporary_slot = @player
    @player = @opponent
    @opponent = temporary_slot
  end
end
