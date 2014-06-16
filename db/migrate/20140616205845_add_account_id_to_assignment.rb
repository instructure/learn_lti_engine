class AddAccountIdToAssignment < ActiveRecord::Migration
  def change
    add_column :learn_lti_engine_assignments, :account_id, :integer
  end
end
