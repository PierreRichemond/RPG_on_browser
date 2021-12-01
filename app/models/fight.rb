class Fight < ApplicationRecord
  has_many :fightfighters, dependent: :destroy
  has_many :fighters, through: :fightfighters



end
