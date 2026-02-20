class GoalsController < ApplicationController
  before_action :set_goal, only: [:show, :edit, :update, :destroy]

  def index
    @q = current_user.goals.ransack(params[:q])
    @pagy, @goals = pagy(@q.result.recent)
  end

  def show
    @q = @goal.meals.ransack(params[:q])
    @meals = @q.result.recent
    @pagy, @meals = pagy(@q.result.recent)
  end

  def new
    @goal = current_user.goals.new(goal_date: Date.today)
    authorize @goal
  end

  def create
    @goal = current_user.goals.new(goal_params)
    authorize @goal

    if @goal.save
      redirect_to @goal, notice: "Goal set for #{@goal.goal_date.strftime('%B %-d')}!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @goal
  end

  def update
    authorize @goal
    if @goal.update(goal_params)
      redirect_to @goal, notice: "Goal updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @goal
    @goal.destroy
    redirect_to goals_path, notice: "Goal deleted."
  end

  private

  def set_goal
    @goal = current_user.goals.find(params[:id])
  end

  def goal_params
    params.require(:goal).permit(:protein_goal, :goal_date, :notes)
  end
end
