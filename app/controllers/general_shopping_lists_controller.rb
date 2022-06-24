class GeneralShoppingListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @total_price = 0
    @foods = current_user.foods.includes(:recipe_foods).map do |food|
      next if food.recipe_foods.empty?

      total_quantity = food.recipe_foods.sum(:quantity)
      price = total_quantity * food.unit_price
      @total_price += price

      {
        name: food.name,
        total_quantity:,
        measurement_unit: food.measurement_unit,
        price:
      }
    end.compact
  end
end
