# -*- ruby -*-
# frozen_string_literal: true

require_relative '../spec_helper'

require 'pushdown/transition'
require 'pushdown/state'


RSpec.describe( Pushdown::Transition ) do

	let( :state_class ) do
		Class.new( Pushdown::State )
	end

	let( :state_a ) { state_class.new }
	let( :state_b ) { state_class.new }


	it "is an abstract class" do
		expect {
			described_class.new( :change_state )
		}.to raise_error( NoMethodError )
	end


	describe 'complete concrete subclass' do

		let( :subclass ) do
			Class.new( described_class ) do

				def initialize( name, new_state, *args )
					super( name, *args )
					@new_state = new_state
				end

				attr_reader :new_state

				def apply( stack )
					stack.push( self.new_state.new )
					return stack
				end

			end
		end

		it "can be instantiated" do
			result = subclass.new( :change_state, state_class )
			expect( result ).to be_a( described_class )
			expect( result.name ).to eq( :change_state )
		end


		it "requires a name to be instantiated" do
			expect {
				subclass.new
			}.to raise_error( ArgumentError, /wrong number of arguments/i )
		end


		it "can alter the stack" do
			stack = [ state_a, state_b ]
			transition = subclass.new( :go_home, state_class )

			result = transition.apply( stack )

			expect( result ).to be_an( Array )
			expect( result.length ).to eq( 3 )
			expect( result.last ).to be_a( state_class )
		end

	end


	describe 'incomplete concrete subclass' do

		let( :subclass ) { Class.new(described_class) }


		it "raises an error when applied to a stack" do
			stack = [ state_a, state_b ]
			transition = subclass.new( :change_state )

			expect {
				transition.apply( stack )
			}.to raise_error( NotImplementedError, /apply/i )
		end

	end

end

