class FoodsController < ActionController::Base
  before_action :authenticate_user!

  def index
    @foods = Food.where(user: current_user)
  end

  def new
    food = Food.new
    respond_to do |format|
      format.html { render :new, locals: { food: } }
    end
  end

  def create
    food = current_user.foods.new(food_params)
    respond_to do |format|
      format.html do
        if food.save
          redirect_to foods_path, notice: 'Food added!'
        else
          redirect_to new_food_path, alert: 'Please, fill all fields'
        end
      end
    end
  end

  def destroy
    Food.find(params[:id]).destroy
    redirect_to foods_path
  end

  private

  def food_params
    params.require(:food).permit(:name, :measurement_unit, :unit_price)
  end
end
