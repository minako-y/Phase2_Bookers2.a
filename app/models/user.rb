class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  # ログイン機能
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # 本、いいね、コメントのアソシエーション
  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  attachment :profile_image, destroy: false

  # 投稿バリデーション
  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  # フォロー・フォロワー機能
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  def following?(user)
    followings.include?(user)
  end

  # 検索機能
  def self.looks(method, words)
    if method == "perfect"
      @user = User.where("name Like ?", "#{words}")
    elsif method == "forward"
      @user = User.where("name Like ?", "#{words}%")
    elsif method == "backward"
      @user = User.where("name Like ?", "%#{words}")
    else
      @user = User.where("name Like ?", "%#{words}%")
    end
  end

  # DM機能
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
end
