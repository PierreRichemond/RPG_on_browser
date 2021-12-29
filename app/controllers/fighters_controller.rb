
class FightersController < ApplicationController
  before_action :set_fighter, only: [:show, :edit, :update, :destroy]

  def index
    @fighters = Fighter.all
  end

  def show
    @gears = @fighter.gears.where(equiped: true)
  end

  def new
    @fighter = Fighter.new
  end

  def create
    @fighter = Fighter.new(
      name: create_fighter_params[:name],
      photo: create_fighter_params[:photo],
      health_point: [19, 20, 21].sample,
      attack: [4, 5, 6, 7].sample,
      defence: [0, 1, 2, 3].sample,
      speed_attack: [10, 11, 12].sample,
      level: 1,
      experience: 0
    )
    if @fighter.save
      redirect_to fighters_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if update_gears_fighter_params.key?(:gear_ids)
      @fighter.fighter_gears.where(equiped: true).update_all(equiped: false)
      ids_in_array = update_gears_fighter_params[:gear_ids].join(" ").split(" ").map {|i| i.to_i}
      ids_in_array.each do |id|
        FighterGear.find(id).update(equiped: true)
      end
      redirect_to fighter_path(@fighter)

    elsif @fighter.valid?
      @fighter.update!(update_fighter_params)
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
    params.require(:fighter).permit(:name, :photo)
  end

  def update_fighter_params
    params.require(:fighter).permit(:name, :photo)
  end

  def update_gears_fighter_params
    params.permit(gear_ids: [])
  end

  def set_fighter
    @fighter = Fighter.find(params[:id])
  end
end
