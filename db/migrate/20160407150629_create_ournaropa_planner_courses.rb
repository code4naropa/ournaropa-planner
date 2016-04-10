class CreateOurnaropaPlannerCourses < ActiveRecord::Migration
  def change
    create_table :ournaropa_planner_courses do |t|
      t.string :name
      t.string :code
      t.string :instructor
      t.text :requirements
      t.text :books
      t.text :description
      t.text :note
      t.text :meeting_times
      t.float :credits

      t.timestamps null: false
    end
  end
end
