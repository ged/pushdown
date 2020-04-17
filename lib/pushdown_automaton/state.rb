# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown_automaton' unless defined?( PushdownAutomaton )


class PushdownAutomaton::State

	### Stack callback -- called when the state is pushed onto the stack of the
	### given +subject+.
	def on_start( subject )
		return nil # no-op
	end


	### Stack callback -- called when the state is popped off the stack of the
	### given +subject+.
	def on_stop( subject )
		return nil # no-op
	end


	### Stack callback -- called when another state is pushed over this one on the
	### given +subject+.
	def on_pause( subject )
		return nil # no-op
	end


	### Stack callback -- called when another state is popped off from this one,
	### making it the current state.
	def on_resume( subject )
		return nil # no-op
	end


	### State callback -- called on an interval by the +subject+ when the state is
	### the current one.
	def update( subject )
		return nil # no-op
	end


	### State callback -- called on an interval by the +subject+ when the state is
	### *not* the current one.
	def shadow_update( subject )
		return nil # no-op
	end

end # class PushdownAutomaton::State

