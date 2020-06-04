class CreateEnterprises < ActiveRecord::Migration[6.0]
  def change
    create_table :enterprises do |t|

      t.string     :name,        null: false
      t.string     :cnpj,        null: false, unique: true
      t.string     :phone,       null: false
      t.text       :description, null: true
      t.references :user,        null: false, foreign_key: true, on_delete: :cascade

      t.timestamps
    end
  end
end
