class MembersController < ApplicationController
  def index
    @members = Member.order("number")
  end

  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy

  end
end
