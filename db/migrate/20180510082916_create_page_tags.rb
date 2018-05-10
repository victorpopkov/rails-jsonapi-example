class CreatePageTags < ActiveRecord::Migration[5.2]
  def change
    create_table :page_tags do |t|
      t.string :name, limit: 3
      t.string :value
      t.belongs_to :page, foreign_key: true

      t.timestamps
    end
  end
end
