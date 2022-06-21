class FoodsController < ActionController::Base
  before_action :authenticate_user!

  def index
    @foods = Food.where(user: current_user)
  end

  def destroy
    Food.find(params[:id]).destroy
    redirect_to foods_path
  end
end