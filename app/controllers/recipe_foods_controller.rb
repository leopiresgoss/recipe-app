class RecipeFoodsController < ApplicationController
  before_action :authenticate_user!

  def index
    @recipe_foods = current_user.recipes.find(params[:recipe_id]).recipe_foods.includes(:food, :recipe)
  end

  def new
    @recipe_food = RecipeFood.new
  end

  def create
    recipe_food_record = RecipeFood.find_by(food_id: recipe_food_params[:food_id], recipe_id: params[:recipe_id])
    if recipe_food_record
      @recipe_food = recipe_food_record
      @recipe_food.quantity += recipe_food_params[:quantity].to_i
    else
      @recipe_food = RecipeFood.new(**recipe_food_params, recipe_id: params[:recipe_id])
    end

    respond_to do |format|
      if @recipe_food.save
        format.html { redirect_to recipe_path(params[:recipe_id]), notice: 'Ingredient added.' }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @recipe_food = RecipeFood.find(params[:id])
  end

  def update
    recipe_food = RecipeFood.find(params[:id])
    respond_to do |format|
      if recipe_food.update(recipe_food_params)
        format.html { redirect_to recipe_path(params[:recipe_id]), notice: 'Ingredient updated.' }
      else
        format.html do
          redirect_to recipe_path(recipe_food), status: :unprocessable_entity,
                                                notice: "#{pluralize(recipe_food.errors.count, 'error')} found: #{
                                                  recipe_food.errors.map(&:full_message).join ', '
                                                }"
        end
      end
    end
  end

  def destroy
    RecipeFood.find(params[:id]).destroy

    respond_to do |format|
      format.html { redirect_to recipe_path(params[:recipe_id]), notice: 'Ingredient removed.', status: :see_other }
    end
  end

  private

  def recipe_food_params
    params.require(:recipe_food).permit(:food_id, :quantity)
  end
end
