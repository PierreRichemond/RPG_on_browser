module FightsHelper

  def experience_earned(opponent, number)
    experience = opponent.level * number
    if opponent.stats_up_hash.values.sum >= 2
      level_taken_by_opponent = number_of_level_up(opponent)
      experience = (opponent.level - level_taken_by_opponent) * number
      # experience taken from the original opponent level(before fight)
    end
    experience
  end

  def number_of_level_up(fighter)
    fighter.stats_up_hash.values.sum / 2
  end

  def show_current_experience(fighter)
    "#{fighter.experience} / #{fighter.level * 10}"
  end

  def available_fighters(all_fighter, picked_fighter = nil)
    all_fighter.reject { |fighter| fighter.name == picked_fighter }
  end

  def show_stats_up_array_details(fighter, stat)
    return '0' if fighter.stats_up_hash[stat] == nil
    return fighter.stats_up_hash[stat] * 4 if stat == :hp
    fighter.stats_up_hash[stat] * 2
  end
end
