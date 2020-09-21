class AddUserIdToPlaces < ActiveRecord::Migration[5.2]
  def up
    execute 'DELETE FROM places;'
    add_reference :places, :user, null: false, index: true
  end
  
  def down
    remove_reference :places, :user, index: true
  end
end
