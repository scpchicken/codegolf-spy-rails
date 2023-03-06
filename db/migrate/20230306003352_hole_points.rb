class HolePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :hole_points do |t|
      t.column :lid, :integer, default: 0
      t.column :hid, :integer, default: 0
      t.column :hole, :text, default: "your hole"
      t.column :lang_best, :text, default: "your lang best"
      t.column :score_best, :integer, default: 0
      # holes => lid 1 | hid 5 | hole "divisors" | lang "python" | score 903
    end
  end
end