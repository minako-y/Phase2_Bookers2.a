class Book < ApplicationRecord
	belongs_to :user
	has_many :favorites, dependent: :destroy
	has_many :favorited_users, through: :favotires, source: :user
	has_many :book_comments, dependent: :destroy

	def favorited_by?(user)
		favorites.where(user_id: user.id).exists?
	end

	validates :title, presence: true
	validates :body, presence: true, length: {maximum: 200}

	is_impressionable counter_cache: true


  def self.looks(method, words)
    if method == "perfect"
      @book = User.where("name Like ?", "#{words}")
    elsif method == "forward"
      @book = User.where("name Like ?", "#{words}%")
    elsif method == "backward"
      @book = User.where("name Like ?", "%#{words}")
    else
      @book = User.where("name Like ?", "%#{words}%")
    end
  end

end
