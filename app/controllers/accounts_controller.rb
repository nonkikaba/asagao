class AccountsController < ApplicationController
  before_action :login_required

  def show
    @member = current_member
  end

  def edit
  end
end
