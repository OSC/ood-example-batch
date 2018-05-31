class Job < ActiveRecord::Base
  # Required parameters
  enum status: [:unsubmitted, :submitted, :completed]
  store :job_params, coder: JSON

  # Hooks
  after_initialize :set_defaults

  # Set default values
  def set_defaults
    self.cluster_id ||= "owens"
  end

  # Custom parameters
  store_accessor :job_params, :project
  store_accessor :job_params, :param1
  store_accessor :job_params, :param2
  store_accessor :job_params, :notes

  # Validations
  validates :project, :param1, :param2, presence: true
end
