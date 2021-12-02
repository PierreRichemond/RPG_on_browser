class Gear < ApplicationRecord
  has_many :fightergears, dependent: :destroy
  has_many :fighters, through: :fightergears


end
