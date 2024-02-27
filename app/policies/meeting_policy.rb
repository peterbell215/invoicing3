# frozen_string_literal: true

# Policy for access to meeting
class MeetingPolicy < ApplicationPolicy
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
