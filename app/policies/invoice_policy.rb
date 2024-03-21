# frozen_string_literal: true

# Policies for access to the Invoices
class InvoicePolicy < ApplicationPolicy
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
