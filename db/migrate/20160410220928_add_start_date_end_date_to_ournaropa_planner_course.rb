class AddStartDateEndDateToOurnaropaPlannerCourse < ActiveRecord::Migration
  def change
    add_column :ournaropa_planner_courses, :start_date, :date
    add_column :ournaropa_planner_courses, :end_date, :date
  end
end
