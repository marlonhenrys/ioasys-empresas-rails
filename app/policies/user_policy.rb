class UserPolicy < ApplicationPolicy

  def show?
    user.id == record.id
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
