# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )


# A switch transition -- remove the current state from the stack and add a
# different one.
class Pushdown::Transition::Switch < Pushdown::Transition

	### Create a transition that will Switch the current State with an instance of
	### the given +state_class+ on the stack.
	def initialize( name, state_class, data=nil )
		super( name )

		@state_class = state_class
		@data = data
	end


	######
	public
	######

	##
	# The State to push to.
	attr_reader :state_class

	##
	# The data object to pass to the #state_class's constructor
	attr_reader :data


	### Apply the transition to the given +stack+.
	def apply( stack )
		raise Pushdown::TransitionError, "can't switch on an empty stack" if stack.empty?

		state = self.state_class.new( self.data )

		self.log.debug "switching current state with a new state: %p" % [ state ]
		old_state = stack.pop
		old_state.on_stop if old_state

		stack.push( state )
		state.on_start

		return stack
	end

end # class Pushdown::Transition::Switch
