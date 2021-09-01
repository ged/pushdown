# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/transition' unless defined?( Pushdown::Transition )
require 'pushdown/exceptions'


# A push transition -- add an instance of a given State to the top of the state
# stack.
class Pushdown::Transition::Pop < Pushdown::Transition


	######
	public
	######

	##
	# Return the state that was popped
	attr_reader :popped_state


	### Apply the transition to the given +stack+.
	def apply( stack )
		raise Pushdown::TransitionError, "can't pop from an empty stack" if stack.empty?
		raise Pushdown::TransitionError, "can't pop the only state on the stack" if stack.length == 1

		self.log.debug "popping a state"
		@popped_state = stack.pop
		@popped_state.on_stop
		stack.last.on_resume

		return stack
	end

end # class Pushdown::Transition::Pop
