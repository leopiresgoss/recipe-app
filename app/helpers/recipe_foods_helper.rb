module RecipeFoodsHelper
  def food_list_for_current_user
    foods = current_user.foods

    r = foods.map do |f|
      [f.name, f.id]
    end

    r.unshift ['--select one--', nil]
  end
end
