# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown' unless defined?( Pushdown )
require 'e2mmap'

module Pushdown
	extend Exception2MessageMapper


	def_exception :Error, "pushdown error"

	def_exception :StateError, "error in state machine", Pushdown::Error
	def_exception :TransitionError, "error while transitioning", Pushdown::Error


end # module Pushdown

