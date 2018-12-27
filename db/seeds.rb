# %wは文字列の配列を作る
table_names = %w(members)
table_names.each do |table_name|
  # Rails.rootはアプリケーションのルートパス(/asagao)を表すオブジェクトを返す。
  # このオブジェクトにjoinメソッドでディレクトリ名をいくつも渡せば
  #「/asagao/db/seeds/development/members.rb」のようにパスを組み立てられる。
  path = Rails.root.join("db/seeds", Rails.env, table_name + ".rb")
  if File.exist?(path)
    puts "Creating #{table_name}..."
    require path
  end
end
