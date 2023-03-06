class LangPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :lang_points do |t|
      t.column :lid, :integer, default: 0
      t.column :hid, :integer, default: 0
      t.column :lang, :text, default: "your lang best"
      t.column :score, :integer, default: 0
    end
    # langs => lid 1 | hid 5 | lang "J" | score 500
  end
end