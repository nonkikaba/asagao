module LessonHelper
  def tiny_format(text)
    h(text).gsub("\n", "<br />").html_safe
    # hメソッドは「<」→「&lt;」のようにHTML特殊文字を変換する。
  end
end
