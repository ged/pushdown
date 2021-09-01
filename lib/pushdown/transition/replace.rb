# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )


# A replace transition -- remove all currents states from the stack and add a
# different one.
class Pushdown::Transition::Replace < Pushdown::Transition

	### Create a transition that will Replace all the states on the current stack
	### with an instance of the given +state_class+.
	def initialize( name, state_class, data=nil )
		super( name )

		@state_class = state_class
		@data = data
	end


	######
	public
	######

	##
	# The State to replace the stack members with.
	attr_reader :state_class

	##
	# The data object to pass to the #state_class's constructor
	attr_reader :data


	### Apply the transition to the given +stack+.
	def apply( stack )
		state = self.state_class.new( self.data )

		self.log.debug "replacing current state with a new state: %p" % [ state ]
		while ( old_state = stack.pop )
			old_state.on_stop
		end

		stack.push( state )
		state.on_start

		return stack
	end

end # class Pushdown::Transition::Replace
