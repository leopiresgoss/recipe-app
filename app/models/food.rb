class Food < ApplicationRecord
  belongs_to :user

  validates_associated :user
  validates :name, :measurement_unit, :price, presence: true
  validates :price, numericality: true
end
