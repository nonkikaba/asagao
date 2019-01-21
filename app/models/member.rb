class Member < ApplicationRecord
  has_secure_password

  # ある会員が削除されると、そのブログ記事も削除される
  has_many :entries, dependent: :destroy
  has_one_attached :profile_picture
  attribute :new_profile_picture

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

  before_save do
    if new_profile_picture
      self.profile_picture = new_profile_picture
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
