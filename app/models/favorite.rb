class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book, counter_cache: :likes_count
end
