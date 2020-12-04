# This adds the ability to easily test Rake tasks without the usual boilerplate
# that goes along with it. Anything in spec/lib/tasks or with the metadata
# `type: :task` automatically loads all the Rake tasks in the application,
# as well as making the Rake task specified in the top level description
# available as a task called `task`, which can then be run with a call to
# `task.execute`

require "rake"

module TaskExampleGroup
  extend ActiveSupport::Concern

  included do
    let(:task_name) { self.class.top_level_description.delete_prefix("rake ") }
    let(:tasks) { Rake::Task }

    # Make the Rake task available as `task` in your examples:
    subject(:task) { tasks[task_name] }
  end
end

RSpec.configure do |config|
  config.define_derived_metadata(file_path: %r{/spec/lib/tasks/}) do |metadata|
    metadata[:type] = :task
  end

  config.include TaskExampleGroup, type: :task

  config.before(:suite) do
    Rails.application.load_tasks
  end
end
