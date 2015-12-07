class UpdateSlugColumn < ActiveRecord::Migration
  def change
    rename_column :posts, :slugs, :slug
    rename_column :categories, :slugs, :slug
    rename_column :users, :slugs, :slug
  end
end
