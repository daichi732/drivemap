class ChangeColumnsAddNotNullToComments < ActiveRecord::Migration[5.2]
  def change
    change_column_null :comments, :user_id, false
    change_column_null :comments, :place_id, false
    change_column_null :comments, :content, false
  end
end
