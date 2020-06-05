class UserPolicy < ApplicationPolicy

  def create?
    user.admin? or user.manager?
  end

  def update?
    true
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
