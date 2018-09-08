class CreateNiches < ActiveRecord::Migration[5.2]
  def change
    create_table :niches do |t|
      t.belongs_to :employer, foreign_key: true
      t.belongs_to :industry, foreign_key: true

      t.timestamps
    end
  end
end
