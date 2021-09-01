# -*- ruby -*-
# frozen_string_literal: true

require_relative '../spec_helper'

# Let autoloads decide the order
require 'pushdown'


RSpec.describe( Pushdown::State ) do

	let( :state_data ) { {} }
	let( :subclass ) do
		Class.new( described_class )
	end

	let( :starting_state_class ) do
		Class.new( subclass )
	end

	let( :automaton_class ) do
		extended_class = Class.new
		extended_class.extend( Pushdown::Automaton )
		extended_class.const_set( :Starting, starting_state_class )
		extended_class.pushdown_state( :state, initial_state: :starting )

		return extended_class
	end


	it "is an abstract class" do
		expect { described_class.new }.to raise_error( NoMethodError, /\bnew\b/ )
	end


	it "knows what the name of its type is" do
		starting_state_class.singleton_class.attr_accessor :name
		starting_state_class.name = 'Acme::State::Starting'

		state = starting_state_class.new

		expect( state.type_name ).to eq( :starting )
	end


	it "handles anonymous classes for #type_name" do
		transition = starting_state_class.new

		expect( transition.type_name ).to eq( :anonymous )
	end



	describe "transition callbacks" do

		it "has a default (no-op) callback for when it is added to the stack" do
			instance = subclass.new
			expect( instance.on_start ).to be_nil
		end


		it "has a default (no-op) callback for when it is removed from the stack" do
			instance = subclass.new
			expect( instance.on_stop ).to be_nil
		end


		it "has a default (no-op) callback for when it is pushed down on the stack" do
			instance = subclass.new
			expect( instance.on_pause ).to be_nil
		end


		it "has a default (no-op) callback for when the stack is popped and it becomes current again" do
			instance = subclass.new
			expect( instance.on_resume ).to be_nil
		end

	end


	describe "event handlers" do

		it "has a default (no-op) event callback" do
			instance = subclass.new
			expect( instance.on_event(:an_event) ).to be_nil
		end

	end


	describe "interval event handlers" do

		it "has a default (no-op) interval callback for when it is current" do
			instance = subclass.new
			expect( instance.update ).to be_nil
		end


		it "has a default (no-op) interval callback for when it is on the stack" do
			instance = subclass.new
			expect( instance.shadow_update ).to be_nil
		end

	end



	describe "transition declaration" do

		it "can declare a push transition" do
			subclass.transition_push( :start, :starting )
			expect( subclass.transitions[:start] ).to eq([ :push, :starting ])
		end


		it "can declare a pop transition" do
			subclass.transition_pop( :undo )
			expect( subclass.transitions[:undo] ).to eq([ :pop ])
		end

	end


	describe "transition creation" do

		it "can create a transition it has declared" do
			subclass.transition_push( :start, :starting )
			instance = subclass.new

			automaton = automaton_class.new

			result = instance.transition( :start, automaton, :state )
			expect( result ).to be_a( Pushdown::Transition::Push )
			expect( result.name ).to eq( :start )
			expect( result.data ).to be_nil
		end


		it "can create a transition it has declared that doesn't take a state class" do
			subclass.transition_pop( :quit )
			instance = subclass.new

			automaton = automaton_class.new

			result = instance.transition( :quit, automaton, :state )
			expect( result ).to be_a( Pushdown::Transition::Pop )
			expect( result.name ).to eq( :quit )
		end

	end

end

