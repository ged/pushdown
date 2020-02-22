#!/usr/bin/env ruby


require 'acme/payment'


payment = Acme::Payment.
	new( from: 'jrandom@example.com', to: 'otherperson@example.com', amount: 150_00 )


payment.process until payment.finished?

