class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.datetime :event_date
      t.string :location
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
