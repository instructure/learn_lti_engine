class AddUuidToLearnLtiEngineStepData < ActiveRecord::Migration
  def change
    add_column :learn_lti_engine_step_data, :uuid, :string
  end
end
