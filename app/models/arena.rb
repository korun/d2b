# -*- encoding : utf-8 -*-

class Arena < ActiveRecord::Base

  BACKGROUND_CONTENT_TYPES = %w[
      image/jpeg
  ].each(&:freeze).freeze

  FOREGROUND_CONTENT_TYPES = %w[
      image/gif
      image/png
  ].each(&:freeze).freeze

  has_attached_file :background #, styles: {medium: '220x300>', thumb: '50x50>'} #, default_url: '/images/:style/missing.png'
  has_attached_file :foreground

  validates :name, presence: true, uniqueness: true, length: {maximum: 255}

  validates_attachment_size         :background, less_than: 5.megabytes
  validates_attachment_file_name    :background, matches: /jpe?g\Z/
  validates_attachment_content_type :background, content_type: BACKGROUND_CONTENT_TYPES

  validates_attachment_size         :foreground, less_than: 1.megabyte
  validates_attachment_file_name    :foreground, matches: [/gif\Z/, /png\Z/]
  validates_attachment_content_type :foreground, content_type: FOREGROUND_CONTENT_TYPES
end
