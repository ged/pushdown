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


	describe "transition callbacks" do

		it "has a default (no-op) callback for when it is added to the stack" do
			instance = subclass.new
			expect( instance.on_start(state_data) ).to be_nil
		end


		it "has a default (no-op) callback for when it is removed from the stack" do
			instance = subclass.new
			expect( instance.on_stop(state_data) ).to be_nil
		end


		it "has a default (no-op) callback for when it is pushed down on the stack" do
			instance = subclass.new
			expect( instance.on_pause(state_data) ).to be_nil
		end


		it "has a default (no-op) callback for when the stack is popped and it becomes current again" do
			instance = subclass.new
			expect( instance.on_resume(state_data) ).to be_nil
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
			expect( instance.update(state_data) ).to be_nil
		end


		it "has a default (no-op) interval callback for when it is on the stack" do
			instance = subclass.new
			expect( instance.shadow_update(state_data) ).to be_nil
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

	end

end

