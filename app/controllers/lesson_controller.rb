class LessonController < ApplicationController
  def step1
    render plain: "こんにちは、#{params[:name]}さん"
  end

  def step2
    render plain: params[:controller] + "#" + params[:action]
  end
end
