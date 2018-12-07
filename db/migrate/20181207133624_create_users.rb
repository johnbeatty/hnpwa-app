class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :hn_id
      t.datetime :created
      t.bigint :delay
      t.bigint :karma
      t.text :about

      t.timestamps
    end
  end
end
