class CreateLearnLtiEngineAccounts < ActiveRecord::Migration
  def change
    create_table :learn_lti_engine_accounts do |t|
      t.string :lti_key
      t.string :lti_secret
      t.string :name

      t.timestamps
    end
  end
end
