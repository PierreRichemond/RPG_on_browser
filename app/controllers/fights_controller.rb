class FightsController < ApplicationController
  def index
    @fights = Fight.all
  end

  def show
    @fight = Fight.find(params[:id])
    @fighters = [@fight.red_fighter, @fight.blue_fighter]
  end

  def create
    first_fighter = Fighter.find_by(name: params[:fight][:first_fighter].split(' ').first)
    second_fighter = Fighter.find_by(name: params[:fight][:second_fighter].split(' ').first)

    if first_fighter == second_fighter
      flash[:danger] = 'Fighters has to be different'
      redirect_to root_path
    else
      fight = FightService.new(first_fighter, second_fighter).run
      redirect_to fight_path(fight)
    end
  end

  private

  def fight_params
    params.require(:fight).permit(:first_fighter, :second_fighter)
  end
end
