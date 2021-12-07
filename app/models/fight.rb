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
    @turns = 0
    @player = players_speed(red_fighter, blue_fighter, @turns)
    @opponent = (@player == red_fighter) ? blue_fighter  : red_fighter
  end

  def run
    @player.stats_up_array = []
    @opponent.stats_up_array = []
    @player.gear_stats_array = []
    @opponent.gear_stats_array = []

    while @players_health[@player.id] >= 0
      @turns += 1
      damage = @player.attack_with_gear - @opponent.defence_with_gear
      damage = 1 if damage <= 1
        @players_health[@opponent.id] = @players_health[@opponent.id] - damage
        self.turns << "#{@player.name} attacks, #{@opponent.name} looses #{damage}Hp, #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."

        switch_player if players_speed(@player, @opponent, @turns) == @opponent
    end
    win_declaration
  end

  def players_speed(red_fighter, blue_fighter, number_of_turns)

  # SPEED_DE_3  red_speed =     0     5        10      15
  # SPEED_DE_5  blue_speed =  0    3     6  9      12     15

  # SPEED_DE_3  red_speed =    0       7         14          21
  # SPEED_DE_7  blue_speed = 0   3   6     9   12     15  18      21

  # SPEED_DE_2  red_speed =      0        4
  # SPEED_DE_4  blue_speed =  0     2  4

      if red_fighter.speed_attack >= blue_fighter.speed_attack && players_speed(red_fighter, blue_fighter, number_of_turns - 1) == red_fighter
        return blue_fighter
      elsif blue_fighter.speed_attack >= red_fighter.speed_attack && players_speed(red_fighter, blue_fighter, number_of_turns - 1) == blue_fighter
        return red_fighter
      end

      array = []
      blue_speed = []
      red_speed = []
      number_of_loop = red_fighter.speed_attack * blue_fighter.speed_attack
      number_of_loop.times do |i|
        if blue_fighter.speed_attack % i == 0
          red_speed << i
          array << i
        end
        if red_fighter.speed_attack % i == 0
          blue_speed << i
          array << i
        end
      end
      value = array.uniq.sort[number_of_turns - 1]
      return red_flighter if red_speed.include?(value)
      return blue_flighter if blue_speed.include?(value)
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
