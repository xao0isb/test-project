# frozen_string_literal: true

class AddRegionToUsersAndPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :region, foreign_key: true
    add_reference :posts, :region, foreign_key: true
  end
end
