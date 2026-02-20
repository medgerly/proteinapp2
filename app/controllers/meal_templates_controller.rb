class MealTemplatesController < ApplicationController
  def index
    @templates = current_user.meal_templates.popular
    render json: @templates.map { |t|
      { id: t.id, meal_name: t.meal_name, protein: t.protein,
        carbs: t.carbs, fat: t.fat, calories: t.calories }
    }
  end

  def destroy
    @template = current_user.meal_templates.find(params[:id])
    @template.destroy
    redirect_back(fallback_location: root_path, notice: "Template removed.")
  end
end
