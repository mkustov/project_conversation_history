# frozen_string_literal: true

class StatusChange < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :from_status, presence: true
  validates :to_status, presence: true

  validates :from_status, :to_status, inclusion: { in: Project::VALID_STATUSES }
end
