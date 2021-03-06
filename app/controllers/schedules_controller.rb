class SchedulesController < ApplicationController
  before_action :login_required
  def create
    @place = Place.find(params[:place_id])
    @schedule = @place.schedules.new(schedule_params)
    if @schedule.save
      render :index
    else
      render :error
    end
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    render :index if @schedule.destroy
  end

  private

  def schedule_params
    # formにてplace_idパラメータを送信,mergeでuser_idを格納
    params.require(:schedule).permit(:date, :place_id).merge(user_id: current_user.id)
  end
end
