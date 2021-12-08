
class FightersController < ApplicationController
  before_action :set_fighter, only: [:show, :edit, :update, :destroy]

  def index
    @fighters = Fighter.all
  end

  def show
    # @fights = []
    # red_fights = Fight.where(red_fighter_id: @fighter)
    # @fighter.fights_when_blue.each {|fight| @fights << fight}
    # break
  end

  def new
    @fighter = Fighter.new
  end

  def create
    @fighter = Fighter.new(fighter_params)
    if @fighter.save
      redirect_to fighters_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @fighter.update!(fighter_params)
      redirect_to fighter_path(@fighter)
    else
      render :edit
    end
  end

  def destroy
    @fighter.destroy!
    redirect_to fighters_path
  end

  private

  def fighter_params
    params.require(:fighter).permit(:name, :health_point, :attack, :defence, :speed_attack, :level, :experience, :photo)
  end

  def set_fighter
    @fighter = Fighter.find(params[:id])
  end
end
