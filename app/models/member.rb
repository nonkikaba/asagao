class Member < ApplicationRecord
  has_secure_password

  # ある会員が削除されると、そのブログ記事も削除される
  has_many :entries, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :voted_entries, through: :votes, source: :entry
  has_one_attached :profile_picture
  attribute :new_profile_picture
  attribute :remove_profile_picture, :boolean

  # 空を禁止、1以上100未満の整数、会員の間で重複を禁止
  validates :number, presence: true,
    numericality: {
      only_integer: true, # 整数のみ
      greater_than: 0, # 0以上
      lass_than: 100, # 100未満
      allow_blank: true # これがないと、空の会員番号を入力した際に「背番号が空」というエラーの他に「背番号が数値ではない」というエラーが発生する
    },
    uniqueness: true

  # 空を禁止、半角英数字のみ、文字列の先頭はアルファベット、２文字以上２０文字以下、会員の間で重複を禁止（大文字個女医を区別しない）
  validates :name, presence: true,
    format: { with: /\A[A-Za-z][A-Za-z0-9]*\z/, allow_blank: true, message: :invalid_member_name },
    length: { minimum: 2, maximun: 20, allow_blank: true },
    uniqueness: { case_sensitive: false }

  validates :full_name, length: { maximum: 20 }
  validates :email, email: { allow_blank: true }

  attr_accessor :current_password
  validates :password, presence: { if: :current_password }

  # new_profile_picture属性がnilでもfalseでもない場合だけ、プロック内のコードを実行してバリデーションを行う
  validate if: :new_profile_picture do
    # respond_toメソッドはあるオブジェクトが特定のメソッドを持っているかどうかを調べてtrueまたはfalseを返す
    # new_profile_pictureがこのメソッドを持っていない場合はそれがフォームからアップロードされた
    # ファイルデータではないことを示す。
    if new_profile_picture.respond_to(:content_type)
      unless new_profile_picture.content_type.in?(ALLOWED_CONTENT_TYPES)
        errors.add(:new_profile_picture, :invalid_image_type)
      end
    else
      errors.add(:new_profile_picture, :inavalid)
    end
  end

  before_save do
    if new_profile_picture
      self.profile_picture = new_profile_picture
    elsif remove_profile_picture
      self.profile_picture.purge
    end
  end

  class << self
    def search(query)
      rel = order("number")
      if query.present?
        rel = rel.where("name LIKE ? OR full_name LIKE ?",
          "%#{query}%", "%#{query}%" )
      end
      rel
    end
  end
end
