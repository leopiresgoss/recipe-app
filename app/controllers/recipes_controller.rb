class RecipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipes = current_user.recipes
  end

  def show
    @recipe = current_user.recipes.find(params[:id])
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(**recipe_params, user: current_user)

    respond_to do |format|
      if @recipe.save
        format.html { redirect_to recipes_path, notice: 'Recipe created successfully.' }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    Recipe.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to recipes_path, notice: 'Recipe deleted successfully.' }
    end
  end

  def update
    recipe = Recipe.find(params[:id])
    respond_to do |format|
      if recipe.update(recipe_params)
        format.html { redirect_to recipe_path(recipe), notice: 'Recipe updated.' }
      else
        format.html { render :show, status: :unprocessable_entity }
      end
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time, :cooking_time, :description, :public)
  end
end
