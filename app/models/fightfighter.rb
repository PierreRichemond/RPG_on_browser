class Fightfighter < ApplicationRecord
  belongs_to :fight
  belongs_to :fighter

  def initialize(fight, array_of_player)
    @player_1 = array_of_player[0]
    @player_2 = array_of_player[1]
    @p1_health_before_fight = @player_1.healthpoint
    @p2_health_before_fight = @player_2.healthpoint
    @fight = fight  #instance nil
    @player = [player_1, player_2].sample
    @opponent = @player_2 if @player == @player_1
    @opponent = @player_1 if @player == @player_2
  end

  def fight_runs
    while @player.health_point >= 0 && @opponent.health_point >= 0
      # if @player.speed_attack - @opponent.speed_attack < @opponent.speed_attack
        @opponent.health_point = @opponent.health_point - (@player.attack - @opponent.defence)
        self.turns << "#{@player.name} attacks, #{@opponent.name} looses #{@player.attack}Hp, #{@opponent.health_point}Hp left for #{@opponent.name}."
        restore_health_point
        win_declaration
        switch_player
        switch_opponent
      # end
    end
    # trouver un moyen de jouer plusieur fois avec un joueur si
    # l'ennemi est trop lent
  end


  def restore_health_point
    if @opponent.health_point <= 0
      @player_1.healthpoint = @p1_health_before_fight
      @player_2.healthpoint = @p2_health_before_fight
    end
  end

  def win_declaration
    @player.win_battle(@opponent.level)
    @opponent.lost_battle(@player.level)
    self.turns << "Congratulation, #{@player} wins!"
    self.winner = @player  # tell who the winner is
  end


  def switch_player
    @player == @player_2 ? @player = @player_1 : @player = @player_2
    @player == @player_1 ? @player = @player_2 : @player = @player_1
  end

  def switch_opponent
    @opponent == @player_1 ? @opponent = @player_2: @opponent = @player_1
    @opponent == @player_2 ? @opponent = @player_1: @opponent = @player_2
  end
end