class ChangeColumnToAllowNull < ActiveRecord::Migration[5.2]
  def up
    change_column :comments, :content,:text, null: true # null: true で日時だけのコメントができるよう変える
  end

  def down
    change_column :comments, :content,:text, null: false
  end
end
