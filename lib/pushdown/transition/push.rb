# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )


# A push transition -- add an instance of a given State to the top of the state
# stack.
class Pushdown::Transition::Push < Pushdown::Transition


	### Create a transition that will Push an instance of the given +state_class+ to
	### the stack.
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
		state = self.state_class.new

		self.log.debug "pushing a new state: %p" % [ state ]
		self.data = stack.last.on_pause( self.data ) if stack.last
		stack.push( state )
		state.on_start( self.data )

		return stack
	end

end # class Pushdown::Transition::Push
