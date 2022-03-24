class AddRoleToGroupMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :group_members, :role, :text
  end
end
