class Project < ApplicationRecord
  VALID_STATUSES = ['Ready', 'In Progress', 'Completed'].freeze
  
  validates :title, presence: true
  validates :description, presence: true

  validates :status, inclusion: { in: VALID_STATUSES }

end
