class FightsController < ApplicationController
  def show
    @fight = Fight.find(params[:id])
  end

  def create

    first_fighter = Fighter.find_by(name: params[:fight][:first_fighter])
    second_fighter = Fighter.find_by(name: params[:fight][:second_fighter])
    fight = Fight.create!(red_fighter: first_fighter, blue_fighter: second_fighter)

    if fight.valid?
      fight.save!
      fight.setup
      fight.run
      redirect_to root_path
      # redirect_to fight_path(fight) # show
    else
      render root_path
    end
  end

  private

  def fight_params
    params.require(:fight).permit(:first_fighter, :second_fighter)
  end
end
