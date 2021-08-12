# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown'


module Acme; end

class Acme::Payment
	extend Pushdown::Automaton


	pushdown_state :state,
		states_from: 'acme/payment_state',
		initial_state: :created


	alias_method :process, :update

end # class Acme::Payment

