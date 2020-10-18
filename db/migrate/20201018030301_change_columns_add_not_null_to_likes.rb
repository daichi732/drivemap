class ChangeColumnsAddNotNullToLikes < ActiveRecord::Migration[5.2]
  def change
    change_column_null :likes, :user_id, false
    change_column_null :likes, :place_id, false
  end
end
