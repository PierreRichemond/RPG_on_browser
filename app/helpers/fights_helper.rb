module FightsHelper

  def experience_earned(current_fighter, opponent, rate)
  #create a ratio of power difference between the fighters
      experience_ratio = opponent.stats[:overall_stats] / current_fighter.stats[:overall_stats].to_f
      # finds out the experience with the ratio
      received_experience = (opponent.level * rate) * experience_ratio
      # setup a minimum experience from a fight
      [received_experience.floor, rate / 2].max
  end

  def number_of_level_up(fighter)
    count = 0
    fighter.stats_up_hash.each do |key, value|
      number_of_stats_gotten = key == :hp ? value / 4 : value / 2
      count += number_of_stats_gotten / 2.0
    end
    count.to_i
  end

  def show_current_experience(fighter)
    "#{fighter.experience} / #{FighterService.experience_per_level(fighter.level)}"
  end

  def available_fighters(all_fighter, picked_fighter = nil)
    all_fighter.reject { |fighter| fighter.name == picked_fighter }
  end

  def show_stats_up_array_details(fighter, stat)
    case stat
      when :hp then "❤️ + #{fighter.stats_up_hash[stat]}"
      when :attack then "⚔️ + #{fighter.stats_up_hash[stat]}"
      when :defence then "🛡 + #{fighter.stats_up_hash[stat]}"
      when :speed_attack then "👟 + #{fighter.stats_up_hash[stat]}"
    end
  end

  def gain_any_even_level?(level, number_of_level_up)
    return false if level.odd? && number_of_level_up <= 2
    true
  end
end
