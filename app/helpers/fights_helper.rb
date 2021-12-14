module FightsHelper

  def experience_earned(opponent, number)
    experience = opponent.level * number
    if (opponent.stats_up_array.count / 2) >= 1
      experience = (opponent.level - 1) * number
    end
    experience
  end
end
