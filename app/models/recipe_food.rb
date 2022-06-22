class RecipeFood < ApplicationRecord
  belongs_to :recipe
  belongs_to :food

  validates_associated :recipe
  validates_associated :food

  validates :food_id, :quantity, presence: true
  validates :quantity, comparison: { greater_than_or_equal_to: 1 }
  validates :quantity, numericality: true
end
