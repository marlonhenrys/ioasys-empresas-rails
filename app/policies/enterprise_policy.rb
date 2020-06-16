class EnterprisePolicy < ApplicationPolicy

  def index?
    user.active?
  end

  def create?
    (user.admin? or user.manager?) && user.active?
  end

  def show?
    user.active?
  end
  
  def update?
    (user.admin? or user.manager?) && user.active?
  end
  
  def destroy?
    (user.admin? or user.manager?) && user.active?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
