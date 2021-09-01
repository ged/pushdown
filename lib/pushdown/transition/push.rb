# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )


# A push transition -- add an instance of a given State to the top of the state
# stack.
class Pushdown::Transition::Push < Pushdown::Transition


	### Create a transition that will Push an instance of the given +state_class+ to
	### the stack.
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
		state = self.state_class.new( self.data )

		self.log.debug "pushing a new state: %p" % [ state ]
		stack.last.on_pause if stack.last
		stack.push( state )
		state.on_start

		return stack
	end

end # class Pushdown::Transition::Push
