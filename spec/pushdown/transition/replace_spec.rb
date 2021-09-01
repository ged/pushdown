# -*- ruby -*-
# frozen_string_literal: true

require_relative '../../spec_helper'

require 'pushdown/transition/replace'
require 'pushdown/state'

RSpec.describe( Pushdown::Transition::Replace ) do

	let( :state_class ) do
		Class.new( Pushdown::State )
	end
	let( :other_state_class ) do
		Class.new( Pushdown::State )
	end

	let( :state_a ) { state_class.new }
	let( :state_b ) { state_class.new }
	let( :state_c ) { state_class.new }
	let( :state_d ) { other_state_class.new }

	let( :stack ) do
		return [ state_a, state_b, state_c ]
	end

	let( :state_data ) { Object.new }


	it "replaces the current stack members with a single new instance of a state when applied" do
		stack = [ state_class.new, state_class.new ]
		transition = described_class.new( :replace_test, other_state_class )

		new_stack = transition.apply( stack )

		expect( new_stack ).to be_an( Array )
		expect( new_stack.length ).to eq( 1 )
		expect( new_stack.last ).to be_a( other_state_class )
	end


	it "passes on state data to the new state if given" do
		stack = []
		transition = described_class.new( :replace_test, state_class, state_data )

		new_stack = transition.apply( stack )

		expect( new_stack.last.data ).to be( state_data )
	end


	it "calls the transition callbacks of all the former states and the new state" do
		new_state = instance_double( other_state_class )
		stack = [
			state_class.new,
			state_class.new,
			other_state_class.new
		]
		transition = described_class.new( :replace_test, other_state_class )

		expect( stack[2] ).to receive( :on_stop ).ordered
		expect( stack[1] ).to receive( :on_stop ).ordered
		expect( stack[0] ).to receive( :on_stop ).ordered

		expect( other_state_class ).to receive( :new ).and_return( new_state )
		expect( new_state ).to receive( :on_start ).ordered

		transition.apply( stack )
	end

end

