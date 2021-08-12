# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )


# A push transition -- add an instance of a given State to the top of the state
# stack.
class Pushdown::Transition::Push < Pushdown::Transition


	### Create a transition that will Push an instance of the given +state_class+ to
	### the stack. Any +args+ given will be passed to the +state_class+'s
	### constructor.
	def initialize( name, state_class, *args )
		super( name, *args )
		@state_class = state_class
	end


	######
	public
	######

	##
	# The State to push to.
	attr_reader :state_class


	### Apply the transition to the given +stack+.
	def apply( stack )
		state = self.state_class.new( *self.args )

		self.log.debug "pushing a new state: %p." % [ state ]
		stack.push( state )

		return stack
	end

end # class Pushdown::Transition::Push
