class Recipe < ApplicationRecord
  belongs_to :user
  has_many :recipe_foods, dependent: :destroy

  validates_associated :user

  validates :name, :preparation_time, :cooking_time, :description, presence: true
  validates :preparation_time, :cooking_time, length: { maximum: 15 }

  def total_price
    recipe_foods.reduce(0) do |sum, n|
      sum + (n.quantity * n.food.unit_price)
    end
  end

  def total_food_items
    recipe_foods.length
  end
end
