# -*- ruby -*-
# frozen_string_literal: true

require_relative '../../spec_helper'

require 'pushdown/transition/switch'
require 'pushdown/state'

RSpec.describe( Pushdown::Transition::Switch ) do

	let( :state_class ) do
		Class.new( Pushdown::State )
	end
	let( :other_state_class ) do
		Class.new( Pushdown::State )
	end

	let( :state_a ) { state_class.new }
	let( :state_b ) { state_class.new }
	let( :state_c ) { other_state_class.new }

	let( :stack ) do
		return [ state_a, state_b ]
	end

	let( :state_data ) { Object.new }


	it "pops the current state off the stack and adds a new state when applied" do
		transition = described_class.new( :switch_test, other_state_class )

		new_stack = transition.apply( stack )

		expect( new_stack ).to be_an( Array )
		expect( new_stack.length ).to eq( 2 )
		expect( new_stack.last ).to be_a( other_state_class )
	end


	it "passes state data through the transition callbacks" do
		transition = described_class.new( :switch_test, other_state_class, state_data )

		expect( state_b ).to receive( :on_stop ).
			with( state_data ).once.and_return( state_data ).ordered

		expect( other_state_class ).to receive( :new ).and_return( state_c )
		expect( state_c ).to receive( :on_start ).with( state_data ).once.ordered

		transition.apply( stack )
	end

end

