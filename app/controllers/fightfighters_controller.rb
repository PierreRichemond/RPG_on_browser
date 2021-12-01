class FightfightersController < ApplicationController
  before_action :set_fightfighter, only: [:show]
  def show
    binding.pry
    @turns = @fightfighter.turns
  end

private

  def fightfighter_params
    params.require(:fightfighter).permit(:first_player, :second_player)
  end

  def set_fightfighter
    @fightfighter = Fightfighter.find(params[:id])
  end
end
