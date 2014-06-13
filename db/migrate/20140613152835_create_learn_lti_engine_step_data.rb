class CreateLearnLtiEngineStepData < ActiveRecord::Migration
  def change
    create_table :learn_lti_engine_step_data do |t|
      t.references :assignment, index: true
      t.string :step
      t.text :data

      t.timestamps
    end
  end
end
