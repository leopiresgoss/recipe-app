class Food < ApplicationRecord
  belongs_to :user

  validates_associated :user
  validates :name, :measurement_unit, :unit_price, presence: true
  validates :unit_price, numericality: true
end
