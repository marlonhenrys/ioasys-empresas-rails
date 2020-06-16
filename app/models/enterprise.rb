class Enterprise < ApplicationRecord
  belongs_to :manager, :class_name => "User", :foreign_key => :user_id
  has_many   :employees, :class_name => "User", dependent: :destroy
  alias_attribute :manager_id, :user_id
  validates :name, :cnpj, :phone, :manager, presence: true
end
