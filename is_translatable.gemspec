$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "is_translatable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "is_translatable"
  s.version     = IsTranslatable::VERSION
  s.authors     = ["Alex Dixon"]
  s.email       = ["dixo0015+is_translatable@gmail.com"]
  s.homepage    = "https://github.com/alexdixon/is_translatable"
  s.summary     = "Simple translation of dynamic db fields."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.1.2"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
end
