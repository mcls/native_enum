require 'spec_helper'

RSpec.describe "ActiveRecord::Tasks::DatabaseTasks" do
  it "works" do
    tasks = ActiveRecord::Tasks::DatabaseTasks
    tasks.database_configuration = {
      'mysql' => {
        'adapter' => 'mysql2',
        'database' => ':memory',
      }
    }
    tasks.db_dir = 'db'
    tasks.migrations_paths = 'db/migrations'
    tasks.root = __dir__
    tasks.create_current('mysql')
  end
end
