class PublicRecipesController < ApplicationController
  def index
    @recipes = Recipe.includes(recipe_foods: [:food]).where(public: true)
  end

  def show
    @recipe = Recipe.includes(recipe_foods: [:food]).find_by(id: params[:id], public: true)

    redirect_to root_path, notice: 'Recipe not found' unless @recipe
  end
end
