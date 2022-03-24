class CreateGroupMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :group_members do |t|
      t.references  :member,  index: true, foreign_key: true
      t.references  :group, index: true, foreign_key: true
      t.timestamps
    end
  end
end
