# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )


# A switch transition -- remove the current state from the stack and add a
# different one.
class Pushdown::Transition::Switch < Pushdown::Transition

	### Create a transition that will Switch the current State with an instance of
	### the given +state_class+ on the stack. Any +args+ given will be passed to the
	### +state_class+'s constructor.
	def initialize( name, state_class, *args )
		super( name, *args )
		@state_class = state_class
	end


	### Apply the transition to the given +stack+.
	def apply( stack )
		state = self.state_class.new( *self.args )

		self.log.debug "switching current state with a new state: %p." % [ state ]
		old_state = stack.pop
		old_state.on_stop(  )
		stack.push( state )

		return stack
	end

end # class Pushdown::Transition::Switch
