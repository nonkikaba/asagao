class Article < ApplicationRecord
  validates :title, :body, :released_at, presence: true
  validates :title, length: { maximum: 80 }
  validates :body, length: { maximum: 2000 }

  def no_expiration
    expired_at.nil?
  end

  def no_expiration=(val)
    @no_expiration = val.in?([true, "1"])
  end

  before_validation do
    self.expired_at = nil if @no_expiration
  end

  validate do
    # 掲載終了日時が設定されていて、それが掲載開始日時よりも前の時点であればエラーになる
    if expired_at && expired_at < released_at
      # errorsメソッドはエラーオブジェクトを返す
      # さらにaddメソッドを足すと、モデルオブジェクトにバリデーションエラーが登録される
      # addメソッドの第一引数には属性名のシンボル、第二引数にはエラーの種類を示すシンボルを指定する
      errors.add(:expired_at, :expired_at_too_old)
    end
  end

  scope :open_to_the_public, -> { where(member_only: false) }

  scope :visible, -> do
    now = Time.current

    where("released_at <= ?", now).where("expired_at > ? OR expired_at IS NULL", now)
  end
end
