class AddFilesToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :files, :json
  end
end
