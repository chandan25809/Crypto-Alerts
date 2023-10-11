class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.uuid :user_id
      t.string :name
      t.string :user_name
      t.string :email
      t.string :password_digest
      t.string :status

      t.timestamps
    end

    add_index :users, :user_id, unique: true
    add_index :users, :user_name, unique: true
    add_index :users, :email, unique: true
  end
end
