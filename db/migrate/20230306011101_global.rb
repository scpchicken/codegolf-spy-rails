class Global < ActiveRecord::Migration[7.0]
  def change
    add_column :globals, :upvote, :integer, default: 0
    add_column :globals, :chicken, :integer, default: 0
    add_column :globals, :time_update, :integer, default: 0
  end
end
