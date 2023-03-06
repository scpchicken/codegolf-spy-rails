class SolutionPoints < ActiveRecord::Migration[7.0]
  def change
    create_table :solution_points do |t|
      t.column :lid, :integer, default: 0
      t.column :login, :text, default: "your login"
      # solution_point => lid 1 | login "scpchicken"
    end
  end
end