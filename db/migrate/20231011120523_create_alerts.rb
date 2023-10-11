class CreateAlerts < ActiveRecord::Migration[7.2]
  def change
    create_table :alerts, id: :uuid, default: -> { 'gen_random_uuid()' } do |t|
      t.references :user, foreign_key: true, type: :uuid
      t.string :symbol
      t.decimal :price, precision: 10, scale: 5
      t.string :state
      t.string :status
      t.timestamp :triggered_at
      t.timestamps
    end
  end
end
