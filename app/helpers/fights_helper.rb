module FightsHelper

  def experience_earned(opponent, number)
    experience = opponent.level * number
    if (opponent.stats_up_array.count / 2) >= 1
      experience = (opponent.level - 1) * number
    end
    experience
  end

  def available_fighters(all_fighter, picked_fighter = nil)
    all_fighter.reject { |fighter| fighter.name == picked_fighter }
  end
end
