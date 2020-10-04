class RemoveDateFromComments < ActiveRecord::Migration[5.2]
  def up
    remove_column :comments, :date
  end

  def down
    add_column :comments, :date, :datetime
  end
end
