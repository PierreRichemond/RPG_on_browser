class FighterService
  class << self # implement all method of the class as a Class method self.method_name
    def create_fighter(name, photo)
      Fighter.create(
        stats: {
          health_point: 20,
          attack: 5,
          gear_attack: 5,
          defence: 1,
          gear_defence: 1,
          speed_attack: 1, # critical hit as well (later on)
          gear_speed_attack: 1,
          # from here will depend on the fighter's speciality:  mana , spell critical hit... (later on)
          intelligence: 5,
          spell_resistance: 1,
          dodge_rate: 10,
          hitting_rate: 80,
          regen: 1,
          overall_stats: 21
        },
        name: name.capitalize,
        photo: photo,
        level: 1,
        experience: 0
      )
    end

    def win_battle(fighter, opponent)
      # 30% chance of getting an item when winning on max level(20)
      if fighter.level == 20
        gears_on_level_max(fighter, 30)
      else
        received_experience = calculates_experience_from_fight(fighter, opponent, 10)
        check_level_up(fighter, received_experience)
      end
    end

    def lost_battle(fighter, opponent)
      # 15% chance of getting an item when winning on max level(20)
      if fighter.level == 20
        gears_on_level_max(fighter, 15)
      else
        received_experience = calculates_experience_from_fight(fighter, opponent, 2)
        check_level_up(fighter, received_experience)
      end
    end

    def edit_character_stats(fighter)
      # edit the stats adding the value of the 1-2 equiped gears
      gear_attack = fighter.fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.attack || 0 }.sum
      fighter.stats[:gear_attack] = fighter.stats[:attack] + gear_attack
      gear_defence = fighter.fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.defence || 0 }.sum
      fighter.stats[:gear_defence] = fighter.stats[:defence] + gear_defence
      gear_speed_attack = fighter.fighter_gears.where(equiped: true).map { |fighter_gear| fighter_gear.gear.speed_attack || 0 }.sum
      fighter.stats[:gear_speed_attack] = fighter.stats[:speed_attack] + gear_speed_attack
      set_overall_stats(fighter)
    end

    def unequiped_all(fighter)
      fighter.fighter_gears.where(equiped: true).update_all(equiped: false)
    end

    def gears_on_level_max(fighter, rate)
      get_gear(fighter) if rate >= rand(0..100)
    end

    def experience_per_level(level)
      # Experience a fighter needs to reach each level to level up
      case level
      when 1..5 then (level * 10)
      when 6..10 then ((level * 10) * 1.5).to_i
      when 11..15 then (level * 10) * 2
      when 16..20 then ((level * 10) * 2.5).to_i
      end
    end

    def check_level_up(fighter, received_experience)
      # add experience and return if no level up
      return fighter.experience += received_experience if received_experience <= (experience_per_level(fighter.level) - fighter.experience)
      # finds how many level the fighter gets for the fight
      number = number_of_level_taken(fighter, received_experience)
      # gives the fighter number of levels taken this fight
      level_up(fighter, number)
    end

    def calculates_experience_from_fight(fighter, opponent, rate)
      #create a ratio of power difference between the fighters
      experience_ratio = opponent.stats[:overall_stats] / fighter.stats[:overall_stats].to_f
      # finds out the experience with the ratio
      received_experience = (opponent.level * rate) * experience_ratio
      # setup a minimum experience from a fight
      [received_experience, rate / 2].max.floor
    end

    def get_gear(fighter)
      # find a gear having a level close from the fighter
      gear = Gear.all.select do |potential_gear|
        potential_gear.level <= fighter.level && potential_gear.level > fighter.level - 6
      end.sample
      # assign the gear to the fighter
      FighterGear.create!(gear_id: gear.id, fighter_id: fighter.id, equiped: false)
      #describe the gear's stats and store in in an array
      gear_stats(fighter, gear)
    end

    def number_of_level_taken(fighter, received_experienced)
      current_level = fighter.level
      current_experience = fighter.experience
      #counts how many level the fighter gets
      count = 0
      experience_to_next_level = experience_per_level(current_level) - current_experience

      while received_experienced >= experience_to_next_level && current_level < 20
        received_experienced -= experience_to_next_level
        # when level up, the figther's experience gots to 0 to easily see the amount of experience he needs to get to the next level
        fighter.experience = 0
        # current_level is a value within the loop only, level gets up in level_up() method
        current_level += 1

        #counts keeps track of level numbers
        count += 1
        experience_to_next_level = experience_per_level(current_level)
      end
      fighter.experience = received_experienced
      count
    end

    def level_up(fighter, number)
      first_level_gained_this_fight = fighter.level + 1
      # add levels on the current level of the fighter
      fighter.level += number
      (first_level_gained_this_fight..fighter.level).each do |level_taken|
        # receive gear only on even level
        get_gear(fighter) if level_taken.even?
      end
      # increase stats each level
      stat_up(fighter, number)
      # adjust the overall stats with the freshly received new stats
      set_overall_stats(fighter)
    end

    def gear_stats(fighter, gear)
      # Create a string with a gear's details
      attack = "#{gear.attack}" if gear.attack.present?
      defence = "#{gear.defence}" if gear.defence.present?
      speed_attack = "#{gear.speed_attack}" if gear.speed_attack.present?
      fighter.new_gear_stats_array << "#{gear.name}: ⚔ #{attack}, 🛡 #{defence}, 👟 #{speed_attack}, Gear level: #{gear.level}"
    end

    def stat_up(fighter, number)
      # Each level, a fighter's stats increase from here
      ( number * 2 ).times do
        case rand(4)
        when 0 then fighter.stats[:health_point] += 4; fighter.stats_up_hash[:hp] += 4
        when 1 then fighter.stats[:attack] += 2; fighter.stats_up_hash[:attack] += 2
        when 2 then fighter.stats[:defence] += 2; fighter.stats_up_hash[:defence] += 2
        when 3 then fighter.stats[:speed_attack] += 2; fighter.stats_up_hash[:speed_attack] += 2
        end
      end
      edit_character_stats(fighter)
    end

    def set_overall_stats(fighter)
      if fighter.stats != {}
        fighter.stats[:overall_stats] = fighter.stats[:gear_speed_attack] + fighter.stats[:gear_attack] + fighter.stats[:gear_defence] + fighter.stats[:health_point]/2
      end
    end
  end
end
