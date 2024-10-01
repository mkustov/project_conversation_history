# frozen_string_literal: true

class Project < ApplicationRecord
  VALID_STATUSES = ['Ready', 'In Progress', 'Completed'].freeze

  validates :title, presence: true
  validates :description, presence: true

  validates :status, inclusion: { in: VALID_STATUSES }

  has_many :comments, dependent: :destroy
  has_many :status_changes, dependent: :destroy

  def conversation_items
    (comments + status_changes).sort_by(&:created_at)
  end
end
