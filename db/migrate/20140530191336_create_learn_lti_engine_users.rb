class CreateLearnLtiEngineUsers < ActiveRecord::Migration
  def change
    create_table :learn_lti_engine_users do |t|
      t.string :lti_user_id

      t.timestamps
    end
  end
end
