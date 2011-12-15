require 'rails/generators'
require 'rails/generators/migration'

# This article helps figure out what's going on with Rails 3 generators:
# http://www.themodestrubyist.com/2010/03/16/rails-3-plugins---part-3---rake-tasks-generators-initializers-oh-my/
module IsTranslatable
  class MigrationGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path('../templates', __FILE__)
  
    # Ugh :(
    # Implement the required interface for Rails::Generators::Migration.
    # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end
  
    def create_translatable_migration
      migration_template 'migration.rb', 'db/migrate/is_translatable_migration'
    end
  end
end
