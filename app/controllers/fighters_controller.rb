
class FightersController < ApplicationController
  before_action :set_fighter, only: [:show, :edit, :update, :destroy]

  def index
    @fighters = Fighter.all
  end

  def show
    @gears = @fighter.gears.where(equiped: true)
    @sorted_gears = @fighter.fighter_gears.sort_by_level
  end

  def new
    @fighter = Fighter.new
  end

  def create
    @fighter = FighterService.create_fighter(create_fighter_params[:name], create_fighter_params[:photo])
    if @fighter.valid?
      flash[:notice] = 'Fighter has been created'
      redirect_to fighters_path
    else
      flash.now[:danger] = 'Fighter has not been created'
      render :new
    end
  end

  def edit
    @sorted_gears = @fighter.fighter_gears.sort_by_level
  end

  def update
    if update_gears_fighter_params.key?(:gear_ids)
      ids_in_array = update_gears_fighter_params[:gear_ids].join(" ").split(" ").map {|i| i.to_i}
      if ids_in_array.size >= 3
        flash[:danger] = 'Fighter\'s gears has not been updated'
        redirect_to fighter_path(@fighter)
      else
        FighterService.unequiped_all(@fighter)
        ids_in_array.each do |id|
          FighterGear.find(id).update(equiped: true)
          FighterService.edit_character_stats(@fighter)
          @fighter.save
        end
        flash[:notice] = 'Fighter\'s gears has been updated'
        redirect_to fighter_path(@fighter)
      end

    elsif @fighter.update(update_fighter_params)
      flash[:notice] = 'Fighter\'s infos has been updated'
      redirect_to fighter_path(@fighter)
    else
      flash[:danger] = 'Fighter\'s details has not been updated'
      redirect_to fighter_path(@fighter)
    end
  end

  def destroy
    @fighter.destroy!
    flash[:notice] = 'Fighter has been deleted properly'
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
