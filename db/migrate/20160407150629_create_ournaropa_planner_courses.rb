class CreateOurnaropaPlannerCourses < ActiveRecord::Migration
  def change
    create_table :ournaropa_planner_courses do |t|
      t.string :name
      t.string :code
      t.text :requirements
      t.text :books

      t.timestamps null: false
    end
  end
end
