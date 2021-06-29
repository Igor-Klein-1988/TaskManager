module TaskStateMachine
  extend ActiveSupport::Concern

  included do
    state_machine initial: :new_task do
      state :new_task
      state :in_development
      state :archived
      state :in_qa
      state :in_code_review
      state :ready_for_release
      state :released

      event :start_develop do
        transition [:new_task, :in_qa, :in_code_review] => :in_development
      end

      event :start_qa do
        transition in_development: :in_qa
      end

      event :to_review do
        transition in_qa: :in_code_review
      end

      event :finish_code_review do
        transition in_code_review: :ready_for_release
      end

      event :release do
        transition ready_for_release: :released
      end

      event :archive do
        transition [:new_task, :released] => :archived
      end
    end
  end
end
