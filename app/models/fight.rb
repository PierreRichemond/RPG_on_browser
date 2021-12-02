class Fight < ApplicationRecord
  belongs_to :red_fighter, class_name: "Fighter"
  belongs_to :blue_fighter, class_name: "Fighter"

  def setup
    @players_health = {
      red_fighter.id => red_fighter.health_point,
      blue_fighter.id => blue_fighter.health_point
    }
    @player = [red_fighter, blue_fighter].sample
    @opponent = (@player == red_fighter) ? blue_fighter  : red_fighter
  end

  def run
    while @players_health[@player.id] >= 0
      # if @player.speed_attack - @opponent.speed_attack < @opponent.speed_attack
        @players_health[@opponent.id] = @players_health[@opponent.id] - (@player.attack - @opponent.defence)
        self.turns << "#{@player.name} attacks, #{@opponent.name} looses #{@player.attack}Hp, #{@players_health[@opponent.id]}Hp left for #{@opponent.name}."
        switch_player
      # end
    end
    win_declaration
    # trouver un moyen de jouer plusieur fois avec un joueur si
    # l'ennemi est trop lent
  end

  def win_declaration
    @opponent.win_battle(@player.level)
    @player.lost_battle(@opponent.level)
    self.turns << "Congratulation, #{@player} wins!"
    self.winner = @player  # tell who the winner is
    @player.save!
    @opponent.save!
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
