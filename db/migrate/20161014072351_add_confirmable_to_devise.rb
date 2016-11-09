class AddConfirmableToDevise < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    execute("UPDATE users SET confirmed_at = NOW()")

    add_index :users, :confirmation_token, unique: true

  end
end
