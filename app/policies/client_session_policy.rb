# frozen_string_literal: true

# Policy for access to client_session
class ClientSessionPolicy < ApplicationPolicy
  def create?
    user.admin?
  end

  def index?
    true
  end

  def show?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end
end
