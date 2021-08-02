class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.references :user, foreign_key: true
      t.string :account_token, null: false, unique: true
      t.decimal :balance

      t.timestamps
    end
  end
end
