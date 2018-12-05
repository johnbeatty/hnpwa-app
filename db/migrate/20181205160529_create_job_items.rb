class CreateJobItems < ActiveRecord::Migration[5.2]
  def change
    create_table :job_items do |t|
      t.references :item, foreign_key: true
      t.bigint :location

      t.timestamps
    end
  end
end
