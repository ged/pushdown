# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown_automaton'


module Acme; end

class Acme::Payment
	extend PushdownAutomaton


	automaton( :state ) do

		states_from 'acme/payment_state'

		initial_state :created
		terminal_states :finished, :canceled

	end


	### Attempt to process the payment further.
	def process
		self.state.update
	end

end # class Acme::Payment

