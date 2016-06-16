class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :sender_id
      t.integer :receiver_id

      t.timestamps null: false
    end
    add_index :relationships, :sender_id
    add_index :relationships, :receiver_id
    add_index :relationships, [:sender_id, :receiver_id], unique: true
  end
end