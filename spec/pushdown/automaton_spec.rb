#!/usr/bin/env rspec -cfd

require_relative '../spec_helper'

require 'pushdown/automaton'


RSpec.describe( Pushdown::Automaton ) do

	let( :extended_class ) do
		the_class = Class.new
		the_class.extend( described_class )
		the_class
	end

	let( :starting_state ) do
		Class.new( Pushdown::State ) do
			transition_push :run, :running
			def on_event( event, * )
				return :run if event == :run
				return nil
			end
		end
	end
	let( :off_state ) { Class.new(Pushdown::State) }
	let( :running_state ) { Class.new(Pushdown::State) }

	let( :state_class_registry ) {{
		starting: starting_state,
		off: off_state,
		running: running_state,
	}}


	it "allows a state attribute to be declared" do
		extended_class.pushdown_state( :state, initial_state: :idle )
		extended_class.const_set( :Idle, starting_state )

		instance = extended_class.new

		expect( instance.state ).to be_a( starting_state )
	end


	it "allows a state class registry to be inferred" do
		extended_class.pushdown_state( :state, initial_state: :starting )
		extended_class.const_set( :Starting, starting_state )

		expect( extended_class.initial_state ).to be( starting_state )
	end


	it "allows a state registry to be passed as a Hash-alike" do
		extended_class.pushdown_state( :status, initial_state: :starting, states: state_class_registry )

		expect( extended_class.initial_status ).to be( starting_state )
	end


	it "allows a state registry to be passed as a (pluggable) Pushdown::State subclass" do
		state_baseclass = Class.new( Pushdown::State ) do
			singleton_class.attr_accessor :subclasses
			def self::get_subclass( classname )
				return subclasses[ classname ]
			end
			def self::create( class_name, *args )
				return self.get_subclass( class_name ).new( *args )
			end
		end

		state_baseclass.subclasses = state_class_registry
		extended_class.pushdown_state( :state, initial_state: :starting, states: state_baseclass )

		expect( extended_class.initial_state ).to be( starting_state )
	end


	it "generates an event method that calls #event and applies transitions for each pushdown state" do
		extended_class.pushdown_state( :state, initial_state: :starting )
		extended_class.const_set( :Starting, starting_state )
		extended_class.const_set( :Off, off_state )
		extended_class.const_set( :Running, running_state )

		instance = extended_class.new

		result = instance.handle_state_event( :run )
		expect( result ).to be_a( Pushdown::Transition::Push )
		expect( instance.state ).to be_a( running_state )
	end

end

