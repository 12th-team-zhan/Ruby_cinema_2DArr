# frozen_string_literal: true

class News < ApplicationRecord
  # friendly_id
  extend FriendlyId
  friendly_id :title, use: :slugged

  # validation
  validates :title, presence: true

  # relationship
  has_rich_text :description
  
  private

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
