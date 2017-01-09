class Micropost < ApplicationRecord
  belongs_to :user
  scope :find_following , ->(user_id) {where "user_id IN (SELECT followed_id FROM relationships
    WHERE follower_id = ?) OR user_id = ?", user_id, user_id}
  default_scope -> {order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_length_140}
  validate  :picture_size

  private

  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, t("message_max_file_size_allowed")
    end
  end
end
