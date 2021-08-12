#!/usr/bin/env ruby

$LOAD_PATH.unshift "examples"

require 'acme/payment'


payment = Acme::Payment.new \
	from: 'jrandom@example.com',
	to: 'otherperson@example.com',
	amount: 150_00


payment.process until payment.finished?

