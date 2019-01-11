class ApplicationController < ActionController::Base
  private def current_member
      Member.find_by(id: session[:member_id]) if session[:member_id]
    end
    # helper_methodは引数に指定された名前のメソッドをテンプレートの中でも使えるメソッドとして登録する
    helper_method :current_member

  class LoginRequired < StandardError; end
  class Forbidden < StandardError; end

  private def login_required
    raise LoginRequired unless current_member
  end
end
