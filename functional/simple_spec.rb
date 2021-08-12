#!/usr/bin/env rspec -cfd

require_relative 'spec_helper'

require 'simple/engine'


RSpec.describe "simple automaton" do

	let( :starting_state ) do
		Class.new( Pushdown::State ) do
			transition_push :started, :running
			transition_pop :didnt_start, :off

			def description
				"is starting"
			end
		end
	end

	let( :running_state ) do
		Class.new( Pushdown::State ) do
			transition_switch :stop, :off

			def description
				"is running"
			end
		end
	end



	it "" do
		fail "it isn't."
	end

end

