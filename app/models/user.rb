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

  def user_permission(user)
    if self.admin?
      user.admin? or user.manager?
    elsif self.manager?
      user.employee?
    end
  end

  def enterprise_permission(enterprise_id)
    if self.admin?
      true
    elsif self.manager?
      self.enterprises.any? { |e| e.id == enterprise_id }
    end
  end

end
