require 'rubygems'
require 'bundler/setup'

require 'is_translatable'
require 'sqlite3'
require 'active_record'

RSpec.configure do |config|
end

# Create test schema and models

ActiveRecord::Base.configurations = {'sqlite3' => {:adapter => 'sqlite3', :database => ':memory:'}}
ActiveRecord::Base.establish_connection('sqlite3')

ActiveRecord::Schema.define(:version => 0) do
	create_table :articles do |t|
		t.string :title
		t.string :body
	end

	create_table :notes do |t|
		t.string :description
	end

	create_table :translations do |t|
		t.string		:translatable_type , :default => ''
		t.integer		:translatable_id
		t.string		:kind
		t.string		:locale, :limit => 5
		t.text			:translation
	end

	class Article < ActiveRecord::Base
		# is_translatable :title, :body
	end

	class Note < ActiveRecord::Base
		# is_translatable :description
	end
end
