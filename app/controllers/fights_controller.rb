
class FightsController < ApplicationController


  def create
    first_fighter = Fighter.find_by(name: params[:first_fighter])
    second_fighter = Fighter.find_by(name: params[:second_fighter])
    red_fighter = RedFighter.create!(fighter_id: first_fighter)
    blue_fighter = BlueFighter.create!(fighter: second_fighter)
    fight = Fight.create!(red_fighter_id: red_fighter, blue_fighter_id: blue_fighter)
    fight.set_up

    binding.pry
    if fight.valid?
      fight.save!
      fight.fight_runs
      redirect_to fight_path(fight) # show
    else
      render root_path
    end
  end

  private

  def fight_params
    params.require(:fight).permit(:first_fighter, :second_fighter)
  end
end
