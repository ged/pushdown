#!/usr/bin/env rspec -cfd

require_relative '../../spec_helper'

require 'pushdown/transition/pop'
require 'pushdown/state'


RSpec.describe( Pushdown::Transition::Pop ) do

	let( :state_class ) do
		Class.new( Pushdown::State )
	end

	let( :state_a ) { state_class.new }
	let( :state_b ) { state_class.new }
	let( :state_c ) { state_class.new }


	it "pops the last state from the stack when applied" do
		stack = [ state_a, state_b, state_c ]
		transition = described_class.new( :pop_test )

		new_stack = transition.apply( stack )

		expect( new_stack ).to eq([ state_a, state_b ])
	end


	it "errors if applied to a stack that has only one state" do
		stack = [ state_a ]
		transition = described_class.new( :pop_test )

		expect {
			transition.apply( stack )
		}.to raise_error( Pushdown::TransitionError, /can't pop/i )
	end

end

