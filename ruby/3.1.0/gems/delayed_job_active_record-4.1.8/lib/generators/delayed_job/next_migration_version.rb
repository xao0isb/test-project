# frozen_string_literal: true

module DelayedJob
  module NextMigrationVersion
    # while methods have moved around this has been the implementation
    # since ActiveRecord 3.0
    def next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      timestamped_migrations =
        if ActiveRecord.respond_to?(:timestamped_migrations)
          ActiveRecord.timestamped_migrations
        else
          ActiveRecord::Base.timestamped_migrations
        end

      if timestamped_migrations
        [Time.now.utc.strftime("%Y%m%d%H%M%S"), format("%.14d", next_migration_number)].max
      else
        format("%.3d", next_migration_number)
      end
    end
  end
end
