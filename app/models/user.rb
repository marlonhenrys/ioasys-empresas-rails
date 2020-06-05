class User < ApplicationRecord
  enum role: [:admin, :manager, :employee]
  enum status: [:active, :disabled]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :job, :class_name => "Enterprise", :foreign_key => :enterprise_id, optional: true
  has_many :enterprises, dependent: :destroy
       
  validates :name, :phone, :role, presence: true

  include Authenticatable

  def check_permission(user)
    if self.id == user.id 
      true
    elsif self.admin?
      user.admin? or user.manager?
    elsif self.manager?
      user.employee? && self.enterprises.any? { |e| e.id == user.enterprise_id }
    end
  end

end
