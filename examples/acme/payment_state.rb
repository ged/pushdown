# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown/state'

require 'acme' unless defined?( Acme )


# Base class for all payment states. Contains any universal behavior shared by every
# state.
class Acme::PaymentState < Pushdown::State

end # class Acme::PaymentState

