class Fight < ApplicationRecord
  belongs_to :red_fighter, class_name: "Fighter"
  belongs_to :blue_fighter, class_name: "Fighter"

  def setup
    @players_health = {
      red_fighter.id => red_fighter.health_point,
      blue_fighter.id => blue_fighter.health_point
    }

    @player = red_fighter.speed_attack > blue_fighter.speed_attack ? red_fighter : blue_fighter
    @opponent = (@player == red_fighter) ? blue_fighter  : red_fighter
  end

  def run
    @player.stats_up_array = []
    @opponent.stats_up_array = []
    @player.gear_stats_array = []
    @opponent.gear_stats_array = []

    while @players_health[@player.id] >= 0
      damage = @player.attack_with_gear - @opponent.defence_with_gear
      if @player.speed_attack > @opponent.speed_attack
        damage = @player.attack_with_gear * (@player.speed_attack / @opponent.speed_attack) - @opponent.defence_with_gear
      end
      damage = 1 if damage <= 1
        @players_health[@opponent.id] = @players_health[@opponent.id] - damage
        turns << "#{@player.name} attacks, #{@opponent.name} looses #{damage}Hp, #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."
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
    if @player == blue_fighter
      @player = red_fighter
      @opponent = blue_fighter
    else
      @player = blue_fighter
      @opponent = red_fighter
    end
  end
end
