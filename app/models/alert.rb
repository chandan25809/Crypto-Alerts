class Alert < ApplicationRecord
    validates :state, inclusion: { in: %w[created triggered deleted] }
    validates :status, inclusion: { in: %w[active inactive] }
    belongs_to :user
end
