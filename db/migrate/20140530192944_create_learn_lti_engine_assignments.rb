class CreateLearnLtiEngineAssignments < ActiveRecord::Migration
  def change
    create_table :learn_lti_engine_assignments do |t|
      t.references :user, index: true
      t.string :type
      t.text :lti_launch_params
      t.text :completed_tasks
      t.string :lti_assignment_id

      t.timestamps
    end
    # add_index :learn_lti_engine_assignments, :lti_assignment_id, unique: true
  end
end
