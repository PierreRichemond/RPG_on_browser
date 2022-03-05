
class FightersController < ApplicationController
  before_action :set_fighter, only: [:show, :edit, :update, :destroy]

  def index
    @fighters = Fighter.all
  end

  def show
    @gears = @fighter.gears.where(equiped: true)
    @sorted_gears = @fighter.fighter_gears.sort_by{|fighter_gear| Gear.find(fighter_gear.gear.id).level}
  end

  def new
    @fighter = Fighter.new(stats: {
        health_point: 20,
        attack: 5,
        gear_attack: 5,
        defence: 1,
        gear_defence: 1,
        speed_attack: 1, # critical hit as well
        gear_speed_attack: 1,
        # from here will depend on the fighter's speciality
        intelligence: 5, # mana , spell critical hit
        spell_resistance: 1,
        dodge_rate: 10,
        hitting_rate: 80,
        regen: 1,
        overall_stats: 31
      })
  end

  def create
    @fighter = Fighter.new(
      stats: {
        health_point: 20,
        attack: 5,
        gear_attack: 5,
        defence: 1,
        gear_defence: 1,
        speed_attack: 1, # critical hit as well
        gear_speed_attack: 1,
        # from here will depend on the fighter's speciality
        intelligence: 5, # mana , spell critical hit
        spell_resistance: 1,
        dodge_rate: 10,
        hitting_rate: 80,
        regen: 1,
        overall_stats: 31
      },
      name: create_fighter_params[:name],
      photo: create_fighter_params[:photo],
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
    @sorted_gears = @fighter.fighter_gears.sort_by{|fighter_gear| Gear.find(fighter_gear.gear.id).level}
  end

  def update
    if update_gears_fighter_params.key?(:gear_ids)
      @fighter.fighter_gears.where(equiped: true).update_all(equiped: false)
      ids_in_array = update_gears_fighter_params[:gear_ids].join(" ").split(" ").map {|i| i.to_i}
      ids_in_array.each do |id|
        FighterGear.find(id).update(equiped: true)
        @fighter.edit_character_stats
        @fighter.save
      end
      redirect_to fighter_path(@fighter)

    elsif @fighter.update(update_fighter_params)
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
