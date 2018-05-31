class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.text :job_params
      t.string :cluster_id
      t.string :job_id
      t.integer :status, default: 0
      t.boolean :staged, default: false
      t.string :staged_name

      t.timestamps null: false
    end
  end
end
