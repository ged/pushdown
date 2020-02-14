# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown_automaton'



class Acme::Payment
	extend PushdownAutomaton


	automaton( :state ) do

		state :created do
			
		end

	end




    # on_start
	# : When a State is added to the stack, this method is called on it.
    # on_stop
	# : When a State is removed from the stack, this method is called on it.
    # on_pause
	# : When a State is pushed over the current one, the current one is paused, 
	#   and this method is called on it.
    # on_resume
	# : When the State that was pushed over the current State is popped, the  
	#   current one resumes, and this method is called on the now-current State.
    # handle_event
	# : Allows easily handling events, like the window closing or a key being  
	#   pressed.
    # fixed_update
	# : This method is called on the active State at a fixed time interval  
	#   (1/60th second by default).
    # update
	# : This method is called on the active State as often as possible by the  
	#   engine.
    # shadow_update
	# : This method is called as often as possible by the engine on all States  
	#   which are on the StateMachines stack, including the active State.  
	#   Unlike update, this does not return a Trans.
    # shadow_fixed_update
	# : This method is called at a fixed time interval (1/60th second by  
	#   default) on all States which are on the StateMachines stack, including  
	#   the active State. Unlike fixed_update, this does not return a Trans.

end # class Acme::Payment