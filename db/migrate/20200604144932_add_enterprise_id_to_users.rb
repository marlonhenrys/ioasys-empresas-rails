class AddEnterpriseIdToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :enterprise, null: true, foreign_key: true, on_delete: :cascade
  end
end
