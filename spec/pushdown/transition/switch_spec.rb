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

	let( :state_data ) { Object.new }



	it "switches the current state the stack with a new one when applied" do
		stack = [ state_class.new, state_class.new ]
		transition = described_class.new( :switch_test, other_state_class )

		new_stack = transition.apply( stack )

		expect( new_stack ).to be_an( Array )
		expect( new_stack.length ).to eq( 2 )
		expect( new_stack.last ).to be_a( other_state_class )
		expect( new_stack.last.data ).to be_nil
	end


	it "passes on state data to the new state if given" do
		stack = [ state_class.new ]
		transition = described_class.new( :switch_test, state_class, state_data )

		new_stack = transition.apply( stack )

		expect( new_stack.last.data ).to be( state_data )
	end


	it "calls the transition callbacks of the former current state and the new state" do
		new_state = instance_double( other_state_class )
		stack = [
			state_class.new,
			state_class.new
		]
		transition = described_class.new( :switch_test, other_state_class )

		expect( stack.last ).to receive( :on_stop )
		expect( other_state_class ).to receive( :new ).and_return( new_state )
		expect( new_state ).to receive( :on_start )

		transition.apply( stack )
	end


	it "errors if applied to an empty stack" do
		stack = []
		transition = described_class.new( :switch_test, other_state_class )

		expect {
			transition.apply( stack )
		}.to raise_error( Pushdown::TransitionError, /can't switch/i )
	end

end

