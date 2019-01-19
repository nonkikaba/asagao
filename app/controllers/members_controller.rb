class MembersController < ApplicationController
  before_action :login_required
  
  def index
    @members = Member.order("number").page(params[:page]).per(15)
  end

  def search
    @members = Member.search(params[:q]).page(params[:page]).per(15)
    render "index"
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new(birthday: Date.new(1980, 1, 1))
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to @member, notice: "会員を登録しました"
    else
      render "new"
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    @member.assign_attributes(member_params)
    if @member.save
      redirect_to @member, notice: "会員情報を更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to :members, notice: "会員を削除しました"
    # indexアクションへリダイレクトする
  end

  private def member_params
    attrs = [
      :number,
      :name,
      :full_name,
      :sex,
      :birthday,
      :email,
      :administrator
    ]
    attrs << :password if params[:action] == "create"

    params.require(:member).permit(attrs)
  end
end
