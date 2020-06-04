class Enterprise < ApplicationRecord
  belongs_to :manager, :class_name => "User", :foreign_key => :user_id
  has_many :employees, dependent: :destroy
  
  validates :name, :cnpj, :phone, :manager, presence: true
end
