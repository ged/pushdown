#!/usr/bin/env rspec -cfd

require_relative '../../spec_helper'

require 'pushdown/transition/push'
require 'pushdown/state'


RSpec.describe( Pushdown::Transition::Push ) do

	let( :state_class ) do
		Class.new( Pushdown::State )
	end

	let( :state_a ) { state_class.new }
	let( :state_b ) { state_class.new }

	let( :stack ) do
		return [ state_a, state_b ]
	end


	it "pushes a new state onto the stack when applied" do
		transition = described_class.new( :push_test, state_class )

		new_stack = transition.apply( stack )

		expect( new_stack ).to be_an( Array )
		expect( new_stack.length ).to eq( 3 )
		expect( new_stack.last ).to be_an_instance_of( state_class )
	end

end

