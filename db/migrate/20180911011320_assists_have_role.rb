class AssistsHaveRole < ActiveRecord::Migration[5.2]
  def change
    add_column :assists, :role_id, :integer
    
    Assist.all.each do |assist|
      assist.role_id = Role.find_or_create_by(:name => assist.role).id
      assist.save
    end
    
    remove_column :assists, :role
  end
end
