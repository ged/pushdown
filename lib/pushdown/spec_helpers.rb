# -*- ruby -*-
# frozen_string_literal: true

require 'rspec'
require 'rspec/matchers'

require 'loggability'

require 'pushdown' unless defined?( Pushdown )


module Pushdown::SpecHelpers


	# RSpec matcher for matching transitions of Pushdown::States
	class StateTransitionMatcher
		extend Loggability
		include RSpec::Matchers

		DEFAULT_CALLBACK = [ :update ]

		log_to :pushdown


		### Create a new matcher that expects a transition to occur.
		def initialize
			@expected_type = nil
			@target_state = nil
			@callback = nil
			@additional_expectations = []
			@state = nil
			@result = nil
			@failure_description = nil
		end


		attr_reader :expected_type,
			:target_state,
			:callback,
			:additional_expectations,
			:state,
			:result,
			:failure_description


		### RSpec matcher API -- returns +true+ if all expectations are met after calling
		### #update on the specified +state+.
		def matches?( state )
			@state = state

			return self.update_ran_without_error? &&
				self.update_returned_transition? &&
				self.correct_transition_type? &&
				self.correct_target_state? &&
				self.matches_additional_expectations?
		end


		### RSpec matcher API -- return a message describing an expectation failure.
		def failure_message
			return "%p: %s" % [ self.state, self.describe_failure ]
		end


		### RSpec matcher API -- return a message describing an expectation being met
		### when the matcher was used in a negated context.
		def failure_message_when_negated
			return "%p: %s" % [ self.state, self.describe_negated_failure ]
		end


		#
		# Mutators
		#

		### Add an additional expectation that the transition that occurs be of the specified
		### +transition_type+.
		def via_transition_type( transition_type )
			@expected_type = transition_type
			return self
		end
		alias_method :via, :via_transition_type


		### Add an additional expectation that the state that is transitioned to be of
		### the given +state_name+. This only applies to transitions that take a target
		### state type. Expecting a particular state_name in transitions which do not take
		### a state is undefined behavior.
		def to_state( state_name )
			@target_state = state_name
			return self
		end
		alias_method :to, :to_state


		### Specify that the operation that should cause the transition is the #update callback.
		### This is the default.
		def on_update
			raise ScriptError, "can't specify more than one callback" if self.callback
			@callback = [ :update ]
			return self
		end


		### Specify that the operation that should cause the transition is the #on_event callback.
		def on_an_event( event, *args )
			raise ScriptError, "can't specify more than one callback" if self.callback
			@callback = [ :on_event, event, *args ]
			return self
		end
		alias_method :on_event, :on_an_event


		#########
		protected
		#########

		### Call the state's update callback and record the result, then return +true+
		### if no exception was raised.
		def update_ran_without_error?
			operation = self.callback || DEFAULT_CALLBACK

			@result = begin
					self.state.public_send( *operation )
				rescue => err
					err
				end

			return !@result.is_a?( Exception )
		end


		### Returns +true+ if the result of calling #update was a Transition or a Symbol
		### that corresponds with a valid transition.
		def update_returned_transition?
			case self.result
			when Pushdown::Transition
				return true
			when Symbol
				return self.state.class.transitions.include?( self.result )
			else
				return false
			end
		end


		### Returns +true+ if a transition type was specified and the transition which
		### occurred was of that type.
		def correct_transition_type?
			type = self.expected_type or return true

			case self.result
			when Pushdown::Transition
				self.result.type_name == type
			when Symbol
				self.state.class.transitions[ self.result ].first == type
			else
				raise "unexpected transition result type %p" % [ self.result ]
			end
		end


		### Returns +true+ if a target state was specified and the transition which
		### occurred was to that state.
		def correct_target_state?
			state_name = self.target_state or return true

			case self.result
			when Pushdown::Transition
				return self.result.respond_to?( :state_class ) &&
					self.result.state_class.type_name == state_name
			when Symbol
				self.state.class.transitions[ self.result ][ 1 ] == state_name
			end
		end


		### Build an appropriate failure messages for the matcher.
		def describe_failure
			desc = String.new( "expected to transition" )
			desc << " via %s" % [ self.expected_type ] if self.expected_type
			desc << " to %s" % [ self.target_state ] if self.target_state

			if self.callback
				methname, *args = self.callback
				desc << " when #%s is called" % [ methname ]
				desc << " with %s" % [ args.map(&:inspect).join(', ') ] if !args.empty?
			end

			desc << ', but '

			case self.result
			when Exception
				err = self.result
				desc << "got %p: %s" % [ err.class, err.message ]
			when Symbol
				transition = self.state.class.transitions[ self.result ]

				if transition
					desc << "it returned a %s transition " % [ transition.first ]
					desc << "to %s " % [ transition[1] ] if transition[1]
					desc << " instead"
				else
					desc << "it returned an unmapped Symbol (%p)" % [ self.result ]
				end
			when Pushdown::Transition
				desc << "it returned a %s transition" % [ self.result.type_name ]
				desc << " to %s" % [ self.result.state_class.type_name ] if
					self.result.respond_to?( :state_class )
				desc << " instead"
			else
				desc << "it did not (returned: %p)" % [ self.result ]
			end

			return desc
		end


		### Build an appropriate failure message for the matcher.
		def describe_negated_failure
			desc = String.new( "expected not to transition" )
			desc << " via %s" % [ self.expected_type ] if self.expected_type
			desc << " to %s" % [ self.target_state ] if self.target_state

			desc << ', but it did.'

			return desc
		end


		### Return an Array of descriptions of the members that were expected to be included in the
		### state body, if any were specified. If none were specified, returns an empty
		### Array.
		def describe_additional_expectations
			return self.additional_expectations.map( &:description )
		end


		### Check that any additional matchers registered via the `.and` mutator also
		### match the parsed state body.
		def matches_additional_expectations?
			return self.additional_expectations.all? do |matcher|
				matcher.matches?( self.parsed_state_body ) or
					fail_with( matcher.failure_message )
			end
		end

	end # class HaveJSONBodyMatcher


	###############
	module_function
	###############

	### Set up an expectation that a transition or valid Symbol will be returned.
	def transition
		return StateTransitionMatcher.new
	end


end # module Pushdown::SpecHelpers


