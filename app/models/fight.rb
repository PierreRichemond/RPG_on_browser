class Fight < ApplicationRecord
  belongs_to :red_fighter, class_name: "Fighter"
  belongs_to :blue_fighter, class_name: "Fighter"

  def setup
    @players_health = {
      red_fighter.id => red_fighter.health_point,
      blue_fighter.id => blue_fighter.health_point
    }
    @players_level = {
      red_fighter.id => red_fighter.level,
      blue_fighter.id => blue_fighter.level
    }
    @player = [red_fighter, blue_fighter].sample
    @opponent = (@player == red_fighter) ? blue_fighter  : red_fighter
  end

  def run
    @player.stats_up_array = []
    @opponent.stats_up_array = []
    while @players_health[@player.id] >= 0
      # if @player.speed_attack - @opponent.speed_attack < @opponent.speed_attack
      attack_defence_difference = @player.attack_with_gear - @opponent.defence_with_gear
      attack_defence_difference = 1 if attack_defence_difference <= 1
        @players_health[@opponent.id] = @players_health[@opponent.id] - attack_defence_difference
        self.turns << "#{@player.name} attacks, #{@opponent.name} looses #{attack_defence_difference}Hp, #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."
        switch_player
      # end
    end
    win_declaration
  end

  def win_declaration
    self.winner = @opponent.name # tell who the winner is
    self.loser = @player.name
    @opponent.win_battle(@player.level)
    @player.lost_battle(@opponent.level)
    @player.save!
    @opponent.save!
    self.turns << "Congratulation, #{self.winner} wins!"
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
