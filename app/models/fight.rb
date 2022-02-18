class Fight < ApplicationRecord
  belongs_to :red_fighter, class_name: "Fighter"
  belongs_to :blue_fighter, class_name: "Fighter"
  validate :cant_fight_self

  def cant_fight_self
    red_fighter != blue_fighter
  end

  def setup
    @players_health = {
      red_fighter.id => red_fighter.stats[:health_point],
      blue_fighter.id => blue_fighter.stats[:health_point]
    }

    @player = red_fighter.stats[:speed_attack_with_gear] > blue_fighter.stats[:speed_attack_with_gear] ? red_fighter : blue_fighter
    @opponent = (@player == red_fighter) ? blue_fighter  : red_fighter
  end

  def run
    @player.stats_up_array = []
    @opponent.stats_up_array = []
    @player.gear_stats_array = []
    @opponent.gear_stats_array = []

    while @players_health[@player.id] >= 0
      damage = @player.stats[:attack_with_gear] - @opponent.stats[:defence_with_gear]
      if @player.stats[:speed_attack_with_gear] > @opponent.stats[:speed_attack_with_gear]
        ratio = (@player.stats[:speed_attack_with_gear] / @opponent.stats[:speed_attack_with_gear]).floor
        damage = (@player.stats[:attack_with_gear] * ratio).floor - @opponent.stats[:defence_with_gear]
      end
      damage = 1 if damage <= 1
      @players_health[@opponent.id] = @players_health[@opponent.id] - damage
      if @players_health[@opponent.id] <= 0
        turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}Hp, #{@opponent.name}."
        switch_player
        break
      end
      turns << "#{@player.name} attacks, #{@opponent.name} loses #{damage}Hp, #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."
      switch_player
    end
    win_declaration
  end

  def win_declaration
    self.winner = @opponent.name
    self.loser = @player.name
    @opponent.win_battle(@player.level)
    @player.lost_battle(@opponent.level)
    @player.save!
    @opponent.save!
    turns << "Congratulation, #{winner} wins!"
  end

  def switch_player
    temporary_slot = @player
    @player = @opponent
    @opponent = temporary_slot
  end
end
