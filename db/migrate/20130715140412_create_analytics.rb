class CreateAnalytics < ActiveRecord::Migration
  def change
    create_table :analytics do |t|
      t.integer :user_id
      t.integer :group
      t.datetime :time
      t.string :action
      t.string :description
      t.string :url
      t.string :category

      t.timestamps
    end
  end
end
