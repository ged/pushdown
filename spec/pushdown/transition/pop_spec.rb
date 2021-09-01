# -*- ruby -*-
# frozen_string_literal: true

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

	let( :stack ) do
		return [ state_a, state_b, state_c ]
	end


	it "pops the last state from the stack when applied" do
		stack = [ state_a, state_b, state_c ]
		transition = described_class.new( :pop_test )

		new_stack = transition.apply( stack )

		expect( new_stack ).to eq([ state_a, state_b ])
	end


	it "passes state data through the transition callbacks" do
		transition = described_class.new( :pop_test )

		expect( state_c ).to receive( :on_stop ).with( no_args ).once.ordered
		expect( state_b ).to receive( :on_resume ).with( no_args ).once.ordered

		transition.apply( stack )
	end


	it "errors if applied to a stack that has only one state" do
		stack = [ state_a ]
		transition = described_class.new( :pop_test )

		expect {
			transition.apply( stack )
		}.to raise_error( Pushdown::TransitionError, /can't pop/i )
	end


	it "errors if applied to an empty stack" do
		stack = []
		transition = described_class.new( :pop_test )

		expect {
			transition.apply( stack )
		}.to raise_error( Pushdown::TransitionError, /can't pop/i )
	end

end

