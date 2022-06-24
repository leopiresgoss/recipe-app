class GeneralShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @foods = Food.joins(recipe_foods: :recipe).where(['recipes.user_id != ?', current_user.id]).map do |food|
      total_quantity = food.recipe_foods.sum(:quantity)

      {
        name: food.name,
        total_quantity:,
        measurement_unit: food.measurement_unit,
        price: total_quantity * food.unit_price
      }
    end

    @total_price = @foods.reduce(0) { |sum, food| sum + food[:price] }
  end
end
