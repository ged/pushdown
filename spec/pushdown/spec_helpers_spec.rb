# -*- ruby -*-
# frozen_string_literal: true

require_relative '../spec_helper'

require 'pushdown/spec_helpers'


RSpec.describe( Pushdown::SpecHelpers ) do

	include Pushdown::SpecHelpers

	#
	# Expectation-failure Matchers (stolen from rspec-expectations)
	# See the README for licensing information.
	#

	def fail
		raise_error( RSpec::Expectations::ExpectationNotMetError )
	end

	def fail_with( message )
		raise_error( RSpec::Expectations::ExpectationNotMetError, message )
	end

	def fail_matching( message )
		if String === message
			regexp = /#{Regexp.escape(message)}/
		else
			regexp = message
		end
		raise_error( RSpec::Expectations::ExpectationNotMetError, regexp )
	end

	def fail_including( *messages )
		raise_error do |err|
			expect( err ).to be_a( RSpec::Expectations::ExpectationNotMetError )
			expect( err.message ).to include( *messages )
		end
	end

	def dedent( string )
		return string.gsub( /^\t+/, '' ).chomp
	end


	let( :state_class ) do
		subclass = Class.new( Pushdown::State )
	end

	let( :seeking_state_class ) do
		subclass = Class.new( Pushdown::State )
		subclass.singleton_class.attr_accessor( :name )
		subclass.name = 'Acme::State::Seeking'
		return subclass
	end



	describe "transition matcher" do

		it "passes if a Pushdown::Transition is returned" do
			state_class.attr_accessor( :seeking_state_class )
			state_class.define_method( :update ) do |*|
				return Pushdown::Transition.create( :push, :change, self.seeking_state_class )
			end

			state = state_class.new
			state.seeking_state_class = seeking_state_class # inject the "seeking" state class

			expect {
				expect( state ).to transition
			}.to_not raise_error
		end


		it "passes if a Symbol that maps to a declared transition is returned" do
			state_class.transition_push( :change, :other )
			state_class.define_method( :update ) do |*|
				return :change
			end

			state = state_class.new

			expect {
				expect( state ).to transition
			}.to_not raise_error
		end


		it "fails if a Symbol that does not map to a declared transition is returned" do
			state_class.transition_push( :change, :other )
			state_class.define_method( :update ) do |*|
				return :something_else
			end

			state = state_class.new

			expect {
				expect( state ).to transition
			}.to fail_matching( /unmapped symbol/i )
		end


		it "fails if something other than a Transition or Symbol is returned" do
			state_class.transition_push( :change, :other )

			state = state_class.new

			expect {
				expect( state ).to transition
			}.to fail_matching( /expected to transition.*it did not/i )
		end

	end


	describe "transition.via mutator" do

		it "passes if the state returns a Symbol that maps to the specified kind of transition" do
			state_class.transition_push( :seek, :seeking )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.via( :push )
			}.to_not raise_error
		end


		it "passes if the state returns a Pushdown::Transition of the correct type" do
			state_class.attr_accessor( :seeking_state_class )
			state_class.define_method( :update ) do |*|
				return Pushdown::Transition.create( :push, :seek, self.seeking_state_class )
			end

			state = state_class.new
			state.seeking_state_class = seeking_state_class # inject the "seeking" state class

			expect {
				expect( state ).to transition.via( :push )
			}.to_not raise_error
		end


		it "fails with a detailed failure message if the state doesn't transition" do
			state_class.transition_push( :seek, :seeking )

			state = state_class.new

			expect {
				expect( state ).to transition.via( :push )
			}.to fail_matching( /expected to transition via push.*returned: nil/i )
		end


		it "fails if the state returns a different kind of Pushdown::Transition" do
			state_class.define_method( :update ) do |*|
				return Pushdown::Transition.create( :pop, :restart )
			end

			state = state_class.new

			expect {
				expect( state ).to transition.via( :push )
			}.to fail_matching( /transition via push.*pop/i )
		end


		it "fails if the state terutns a Symbol that maps to the wrong kind of transition" do
			state_class.transition_pop( :seek )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.via( :push )
			}.to fail_matching( /transition via push.*it returned a pop/i )
		end

	end


	describe "transition.to mutator" do

		it "passes if the state returns a Symbol that maps to a transition to the specified state" do
			state_class.transition_push( :seek, :seeking )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.to( :seeking )
			}.to_not raise_error
		end


		it "passes if the state returns a Pushdown::Transition with the correct target state" do
			state_class.attr_accessor( :seeking_state_class )
			state_class.define_method( :update ) do |*|
				return Pushdown::Transition.create( :push, :seek, self.seeking_state_class )
			end

			state = state_class.new
			state.seeking_state_class = seeking_state_class # inject the "seeking" state class

			expect {
				expect( state ).to transition.to( :seeking )
			}.to_not raise_error
		end


		it "fails if the state returns a Symbol that maps to a transition to a different state" do
			state_class.transition_push( :seek, :seeking )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.to( :broadcasting )
			}.to fail_matching( /broadcasting.*seeking/i )
		end


		it "fails with a detailed failure message if the state doesn't transition" do
			state_class.transition_push( :seek, :seeking )

			state = state_class.new

			expect {
				expect( state ).to transition.to( :seeking )
			}.to fail_matching( /to seeking.*returned: nil/i )
		end


		it "fails if a Pushdown::Transition with a different target state is returned" do
			state_class.attr_accessor( :seeking_state_class )
			state_class.define_method( :update ) do |*|
				return Pushdown::Transition.create( :push, :seek, self.seeking_state_class )
			end

			state = state_class.new
			state.seeking_state_class = seeking_state_class # inject the "seeking" state class

			expect {
				expect( state ).to transition.to( :other )
			}.to fail_matching( /other.*seeking/i )
		end

	end


	describe "composed matcher" do

		it "passes if both .to and .via are specified and match" do
			state_class.transition_push( :seek, :seeking )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.via( :push ).to( :seeking )
			}.to_not raise_error
		end


		it "fails if both .to and .via are specified and .to doesn't match" do
			state_class.transition_push( :seek, :broadcasting )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.via( :push ).to( :seeking )
			}.to fail_matching( /seeking.*broadcasting/i )
		end


		it "fails if both .to and .via are specified and .via doesn't match" do
			state_class.transition_push( :seek, :broadcasting )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.via( :switch ).to( :broadcasting )
			}.to fail_matching( /switch.*push/i )
		end


		it "fails if both .to and .via are specified and neither match" do
			state_class.transition_push( :seek, :broadcasting )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).to transition.via( :switch ).to( :seeking )
			}.to fail_matching( /switch.*seeking.*push.*broadcasting/i )
		end

	end


	describe "operation mutators" do

		it "allows the #update operation to be explicitly specified" do
			state_class.transition_push( :change, :other )
			state_class.define_method( :update ) do |*|
				return :change
			end
			state_class.define_method( :on_event ) do |*|
				return nil
			end

			state = state_class.new

			expect {
				expect( state ).to transition.on_update
			}.to_not raise_error
		end


		it "allows the #on_event operation to be explicitly specified" do
			state_class.transition_push( :change, :other )
			state_class.define_method( :on_event ) do |*|
				return :change
			end

			state = state_class.new

			expect {
				expect( state ).to transition.on_an_event( :foo )
			}.to_not raise_error
		end


		it "supports giving additional arguments to pass the #on_event operation" do
			state_class.transition_push( :change, :other )

			state = state_class.new
			expect( state ).to receive( :on_event ).with( :foo, 1, "another arg" ).
				and_return( :change )

			expect {
				expect( state ).to transition.on_an_event( :foo, 1, "another arg" )
			}.to_not raise_error
		end


		it "adds the callback to the description if on_update is specified" do
			state_class.transition_push( :change, :other )

			state = state_class.new

			expect {
				expect( state ).to transition.on_update
			}.to fail_matching( /transition when #update is called/i )
		end


		it "adds the callback to the description if on_an_event is specified" do
			state_class.transition_push( :change, :other )

			state = state_class.new

			expect {
				expect( state ).to transition.on_an_event( :foo )
			}.to fail_matching( /transition when #on_event is called with :foo/i )
		end

	end

	describe "negated matcher" do

		it "succeeds if a Symbol that does not map to a declared transition is returned" do
			state_class.transition_push( :change, :other )
			state_class.define_method( :update ) do |*|
				return :something_else
			end

			state = state_class.new

			expect {
				expect( state ).not_to transition
			}.to_not raise_error
		end


		it "succeeds if something other than a Transition or Symbol is returned" do
			state_class.transition_push( :change, :other )

			state = state_class.new

			expect {
				expect( state ).not_to transition
			}.to_not raise_error
		end


		it "succeeds if a specific transition is given, but a different one is returned" do
			state_class.transition_push( :change, :other )
			state_class.define_method( :update ) do |*|
				return :change
			end

			state = state_class.new

			expect {
				expect( state ).not_to transition.via( :switch )
			}.to_not raise_error
		end


		it "succeeds if a target state is given, but a different one is returned" do
			state_class.transition_push( :change, :broadcasting )
			state_class.define_method( :update ) do |*|
				return :change
			end

			state = state_class.new

			expect {
				expect( state ).not_to transition.via( :push ).to( :seeking )
			}.to_not raise_error
		end


		it "fails if a Pushdown::Transition is returned" do
			state_class.attr_accessor( :seeking_state_class )
			state_class.define_method( :update ) do |*|
				return Pushdown::Transition.create( :push, :change, self.seeking_state_class )
			end

			state = state_class.new
			state.seeking_state_class = seeking_state_class # inject the "seeking" state class

			expect {
				expect( state ).not_to transition
			}.to fail_matching( /not to transition, but it did/i )
		end


		it "fails if a Symbol that maps to a declared transition is returned" do
			state_class.transition_push( :change, :other )
			state_class.define_method( :update ) do |*|
				return :change
			end

			state = state_class.new

			expect {
				expect( state ).not_to transition
			}.to fail_matching( /not to transition, but it did/i )
		end


		it "fails if a type and state are specified and they describe the returned transition" do
			state_class.transition_push( :seek, :seeking )
			state_class.define_method( :update ) do |*|
				return :seek
			end

			state = state_class.new

			expect {
				expect( state ).not_to transition.via( :push ).to( :seeking )
			}.to fail_matching( /not.*via push to seeking, but it did/i )
		end

	end


end
