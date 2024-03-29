class User < ActiveRecord::Base
  has_many :group_sessions, foreign_key: :host_id

  has_many :bookings
  has_many :booked_sessions, through: :bookings, source: :group_session

  has_attached_file :avatar, path: "/public/system/accounts/:id/:style/:filename",
                             url: ":s3_domain_url",
                             default_url: :gravatar_url,
                             default_style: :thumb,
                             styles: {
                               medium: "300x300>",
                               thumb: "100x100>",
                               tiny: '50x50>'
                             }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def gravatar_url
    Gravatar.new(email).image_url(size: 100)
  end

  def is_guest?
    false
  end

  def name
    [first_name, last_name].join(' ')
  end
end
