# -*- encoding: utf-8 -*-
# stub: pushdown 0.3.0.pre.20210901151908 ruby lib

Gem::Specification.new do |s|
  s.name = "pushdown".freeze
  s.version = "0.3.0.pre.20210901151908"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "http://todo.sr.ht/~ged/Pushdown", "changelog_uri" => "http://deveiate.org/code/pushdown/History_md.html", "documentation_uri" => "http://deveiate.org/code/pushdown", "homepage_uri" => "http://hg.sr.ht/~ged/Pushdown", "source_uri" => "http://hg.sr.ht/~ged/Pushdown" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Granger".freeze]
  s.date = "2021-09-01"
  s.description = "A pushdown automaton toolkit for Ruby. It&#39;s based on the State Manager from the Amethyst project.".freeze
  s.email = ["ged@faeriemud.org".freeze]
  s.files = ["History.md".freeze, "LICENSE.txt".freeze, "README.md".freeze, "lib/pushdown.rb".freeze, "lib/pushdown/automaton.rb".freeze, "lib/pushdown/exceptions.rb".freeze, "lib/pushdown/spec_helpers.rb".freeze, "lib/pushdown/state.rb".freeze, "lib/pushdown/transition.rb".freeze, "lib/pushdown/transition/pop.rb".freeze, "lib/pushdown/transition/push.rb".freeze, "lib/pushdown/transition/replace.rb".freeze, "lib/pushdown/transition/switch.rb".freeze, "spec/pushdown/automaton_spec.rb".freeze, "spec/pushdown/spec_helpers_spec.rb".freeze, "spec/pushdown/state_spec.rb".freeze, "spec/pushdown/transition/pop_spec.rb".freeze, "spec/pushdown/transition/push_spec.rb".freeze, "spec/pushdown/transition/replace_spec.rb".freeze, "spec/pushdown/transition/switch_spec.rb".freeze, "spec/pushdown/transition_spec.rb".freeze, "spec/pushdown_spec.rb".freeze, "spec/spec_helper.rb".freeze]
  s.homepage = "http://hg.sr.ht/~ged/Pushdown".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "3.1.6".freeze
  s.summary = "A pushdown automaton toolkit for Ruby.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<loggability>.freeze, ["~> 0.18"])
    s.add_runtime_dependency(%q<pluggability>.freeze, ["~> 0.7"])
    s.add_runtime_dependency(%q<e2mmap>.freeze, ["~> 0.1"])
    s.add_development_dependency(%q<rake-deveiate>.freeze, ["~> 0.5"])
  else
    s.add_dependency(%q<loggability>.freeze, ["~> 0.18"])
    s.add_dependency(%q<pluggability>.freeze, ["~> 0.7"])
    s.add_dependency(%q<e2mmap>.freeze, ["~> 0.1"])
    s.add_dependency(%q<rake-deveiate>.freeze, ["~> 0.5"])
  end
end
