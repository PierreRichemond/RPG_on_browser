
class FightsController < ApplicationController

  def create
    @fight = Fightfighter.find(params[:id])
    player_1 = params[:first_player]
    player_2 = params[:second_player]
    fight = Fighter.create!(fight_params)

    fight_fighter = Fightfighter.new(fight, [player_1, player_2])
    binding.pry
    if fight_fighter.valid?
      fight_fighter.save!

      fight_fighter.fight_runs
      redirect_to fightfighter_path(fight_fighter) # show
    else
      render root_path
    end
  end

  private

  def fight_params
    params.require(:fight).permit(:first_fighter, :second_fighter)
  end
end
