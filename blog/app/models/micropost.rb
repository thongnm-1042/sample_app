class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze

  belongs_to :user

  has_one_attached :image

  delegate :name, to: :user

  validates :user_id, presence: true
  validates :content, presence: true,
     length: {maximum: Settings.number.max_content}
  validates :image, content_type: {in: Settings.number.in,
                                   message:
                                    I18n.t("microposts.image_valid")},
                           size: {less_than_or_equal_to:
                                    Settings.number.size_less.megabytes,
                                  message: I18n.t("microposts.size_file")}

  scope :order_created_at, ->{order created_at: :desc}
  scope :micropost_feed, ->user_ids{where user_id: user_ids}

  def display_image
    image.variant resize_to_limit: Settings.number.resize_to_limit
  end
end
