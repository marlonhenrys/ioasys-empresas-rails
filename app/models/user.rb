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

  def self?(user)
    self.id == user.id 
  end

  def master?(user)
    if self.admin?
      user.admin? or user.manager?
    elsif self.manager?
      user.employee? && self.enterprises.any? { |e| e.id == user.enterprise_id }
    end
  end

  def coworker?(user)
    self.employee? && user.employee? && self.enterprise_id == user.enterprise_id && !self?(user)
  end

  def have_control?(user)
    master?(user) or self?(user)
  end

  def have_access?(user)
    self.admin? or coworker?(user) or have_control?(user)
  end

  def current_job?(enterprise)
    self.employee? && self.enterprise_id == enterprise.id
  end

  def enterprise_manager?(enterprise)
    self.manager? && enterprise.user_id == self.id
  end

  def have_access_enterprise?(enterprise)
    self.admin? or enterprise_manager?(enterprise) or current_job?(enterprise)
  end

  def have_control_enterprise?(enterprise)
    self.admin? or enterprise_manager?(enterprise)
  end

end
