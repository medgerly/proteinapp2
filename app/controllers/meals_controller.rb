class MealsController < ApplicationController
  before_action :set_goal
  before_action :set_meal, only: [:show, :edit, :update, :destroy]

  def new
    @meal = @goal.meals.new(logged_on: @goal.goal_date)
    @templates = current_user.meal_templates.popular.limit(10)
    authorize @meal
  end

  def create
    @meal = @goal.meals.new(meal_params)
    authorize @meal

    if @meal.save
      respond_to do |format|
        format.html { redirect_to goal_path(@goal), notice: "#{@meal.meal_name} logged (#{@meal.protein}g protein)!" }
        format.turbo_stream
      end
    else
      @templates = current_user.meal_templates.popular.limit(10)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @meal
    @templates = current_user.meal_templates.popular.limit(10)
  end

  def update
    authorize @meal
    if @meal.update(meal_params)
      redirect_to goal_path(@goal), notice: "Meal updated."
    else
      @templates = current_user.meal_templates.popular.limit(10)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @meal
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to goal_path(@goal), notice: "Meal removed." }
      format.turbo_stream
    end
  end

  def estimate
    authorize @goal.meals.new, :create?
    description = params[:description]
    result = AiMealEstimator.call(description)
    render json: result
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:goal_id])
  end

  def set_meal
    @meal = @goal.meals.find(params[:id])
  end

  def meal_params
    params.require(:meal).permit(:meal_name, :protein, :carbs, :fat, :calories, :meal_image, :logged_on, :remove_meal_image)
  end
end
