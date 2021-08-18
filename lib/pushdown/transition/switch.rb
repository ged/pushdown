# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )


# A switch transition -- remove the current state from the stack and add a
# different one.
class Pushdown::Transition::Switch < Pushdown::Transition

	### Create a transition that will Switch the current State with an instance of
	### the given +state_class+ on the stack.
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

		self.log.debug "switching current state with a new state: %p" % [ state ]
		old_state = stack.pop
		self.data = old_state.on_stop( self.data )
		stack.push( state )
		state.on_start( self.data )

		return stack
	end

end # class Pushdown::Transition::Switch
