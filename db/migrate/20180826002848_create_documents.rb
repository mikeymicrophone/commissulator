class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :name
      t.string :role
      t.belongs_to :deal
      t.belongs_to :agent

      t.timestamps
    end
  end
end
