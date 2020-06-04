class UserPolicy < ApplicationPolicy

  def create?
    user.admin? or user.manager?
  end
  
  def show?
    user.id == record.id
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
