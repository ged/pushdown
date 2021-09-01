# -*- ruby -*-
# frozen_string_literal: true

require_relative '../../spec_helper'

require 'pushdown'
require 'pushdown/transition/push'


RSpec.describe( Pushdown::Transition::Push ) do

	let( :state_class ) do
		Class.new( Pushdown::State )
	end
	let( :other_state_class ) do
		Class.new( Pushdown::State )
	end

	let( :state_data ) { Object.new }



	it "pushes a new state onto the stack when applied" do
		stack = [ state_class.new, state_class.new ]
		transition = described_class.new( :push_test, other_state_class )

		new_stack = transition.apply( stack )

		expect( new_stack ).to be_an( Array )
		expect( new_stack.length ).to eq( 3 )
		expect( new_stack.last ).to be_a( other_state_class )
		expect( new_stack.last.data ).to be_nil
	end


	it "passes on state data to the new state if given" do
		stack = []
		transition = described_class.new( :push_test, state_class, state_data )

		new_stack = transition.apply( stack )

		expect( new_stack.last.data ).to be( state_data )
	end


	it "calls the transition callbacks of the former current state and the new state" do
		new_state = instance_double( other_state_class )
		stack = [
			state_class.new,
			state_class.new
		]
		transition = described_class.new( :push_test, other_state_class )

		expect( stack.last ).to receive( :on_pause )
		expect( other_state_class ).to receive( :new ).and_return( new_state )
		expect( new_state ).to receive( :on_start )

		transition.apply( stack )
	end

end

