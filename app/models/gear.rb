# == Schema Information
#
# Table name: gears
#
#  id           :bigint           not null, primary key
#  attack       :integer
#  defence      :integer
#  level        :integer
#  name         :string
#  speed_attack :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Gear < ApplicationRecord
  has_many :fightergears, dependent: :destroy
  has_many :fighters, through: :fightergears
end
