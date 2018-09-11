class CreateInvolvements < ActiveRecord::Migration[5.2]
  def change
    create_table :involvements do |t|
      t.belongs_to :package, foreign_key: true
      t.belongs_to :role, foreign_key: true
      t.decimal :rate
      t.text :description

      t.timestamps
    end
  end
end
