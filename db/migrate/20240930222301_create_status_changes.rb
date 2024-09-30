# frozen_string_literal: true

class CreateStatusChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :status_changes do |t|
      t.references :user, null: false, foreign_key: true
      t.string :from_status, null: false
      t.string :to_status, null: false
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
