# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :role, null: false, default: "user"
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :middle_name, null: false

      t.timestamps
    end
  end
end
