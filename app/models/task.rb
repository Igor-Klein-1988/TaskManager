class Task < ApplicationRecord
  include TaskStateMachine
  extend Enumerize

  STATES = [:new_task, :in_development, :archived, :in_qa, :in_code_review, :ready_for_release, :released].freeze
  enumerize :state, in: STATES, predicates: true

  belongs_to :author, class_name: 'User'
  belongs_to :assignee, class_name: 'User', optional: true

  validates :name, :description, :author, :state, presence: true
  validates :description, length: { maximum: 500 }
end
