class AddIndexToCode < ActiveRecord::Migration
  def change
    add_index :ournaropa_planner_courses, :code
  end
end
