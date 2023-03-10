require_relative "lib/kanban7/version"

Gem::Specification.new do |spec|
  spec.name        = "kanban7"
  spec.version     = Kanban7::VERSION
  spec.authors     = ["lam phan"]
  spec.email       = ["theforestvn88@gmail.com"]
  spec.homepage    = "https://github.com/theforestvn88/rails_kanban7"
  spec.summary     = "Kanban"
  spec.description = "Kanban"
  spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://github.com/theforestvn88/rails_kanban7"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/theforestvn88/rails_kanban7"
  spec.metadata["changelog_uri"] = "https://github.com/theforestvn88/rails_kanban7"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.4.2"
end
