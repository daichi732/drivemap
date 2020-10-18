class ChangeColumnsAddNotNullToSchedules < ActiveRecord::Migration[5.2]
  def change
    change_column_null :schedules, :user_id, false
    change_column_null :schedules, :place_id, false
    change_column_null :schedules, :date, false
  end
end
