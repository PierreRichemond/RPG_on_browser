
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
    @gears = @fighter.gears.where(equiped: true)
  end

  def new
    @fighter = Fighter.new
  end

  def create
    @fighter = Fighter.new(create_fighter_params)
    if @fighter.save
      redirect_to fighters_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if update_fighter_params.key?(:gear_ids)
      @fighter.fighter_gears.where(equiped: true).update_all(equiped: false)
      @fighter.fighter_gears.where(id: update_fighter_params[:gear_ids]).update_all(equiped: true)
      redirect_to fighter_path(@fighter)
    elsif @fighter.update!(update_fighter_params)

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

  def create_fighter_params
    params.require(:fighter).permit(:name, :health_point, :attack, :defence, :speed_attack, :level, :experience, :photo)
  end

  def update_fighter_params
    params.permit(:name, :photo, gear_ids: [])
  end

  def set_fighter
    @fighter = Fighter.find(params[:id])
  end
end
