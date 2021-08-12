# -*- encoding: utf-8 -*-
# stub: pushdown 0.1.0.pre.20210714190141 ruby lib

Gem::Specification.new do |s|
  s.name = "pushdown".freeze
  s.version = "0.1.0.pre.20210714190141"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://todo.sr.ht/~ged/Pushdown", "changelog_uri" => "http://deveiate.org/code/pushdown/History_md.html", "documentation_uri" => "http://deveiate.org/code/pushdown", "homepage_uri" => "http://hg.sr.ht/~ged/Pushdown", "source_uri" => "http://hg.sr.ht/~ged/Pushdown" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze]
  s.date = "2021-07-14"
  s.description = "A pushdown automaton toolkit for Ruby. It&#39;s based on the State Manager from the Amethyst project.".freeze
  s.email = ["ged@faeriemud.org".freeze]
  s.files = [".simplecov".freeze, "History.md".freeze, "README.md".freeze, "Rakefile".freeze, "lib/pushdown.rb".freeze, "spec/pushdown_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://hg.sr.ht/~ged/Pushdown".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A pushdown automaton toolkit for Ruby.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<rake-deveiate>.freeze, ["~> 0.5"])
  else
    s.add_dependency(%q<rake-deveiate>.freeze, ["~> 0.5"])
  end
end
