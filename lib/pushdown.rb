# -*- ruby -*-
# frozen_string_literal: true

require 'loggability'

# Pushdown -- a pushdown automaton implementation for Ruby.
#
# Starting points:
#
# - Pushdown::Automaton
# - Pushdown::State
# - Pushdown::Transition
#
module Pushdown
	extend Loggability

	# Package version
	VERSION = '0.0.1'


	# Loggability API -- create a logger for Pushdown classes and modules
	log_as :pushdown

	autoload :Transition, 'pushdown/transition'
	autoload :State, 'pushdown/state'
	autoload :Automaton, 'pushdown/automaton'

end # module Pushdown

Pushdown::Transition.plugin_exclusions( '**/spec/pushdown/transition/**' )
Pushdown::Transition.load_all
