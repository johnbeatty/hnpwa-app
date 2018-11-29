class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.bigint :hn_id
      t.bigint :parent_id
      t.boolean :deleted
      t.integer :hn_type
      t.string :by
      t.datetime :time
      t.text :text
      t.boolean :dead
      t.bigint :parent
      t.bigint :poll
      t.string :url
      t.string :host
      t.integer :score
      t.string :title
      t.integer :descendants

      t.timestamps
    end
  end
end
