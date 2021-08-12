# -*- ruby -*-
# frozen_string_literal: true

require 'loggability'

require 'pushdown' unless defined?( Pushdown )


# A mixin that adds pushdown-automaton functionality to another module/class.
module Pushdown::Automaton
	extend Loggability

	# Loggability API -- log to the pushdown logger
	log_to :pushdown


	### Extension callback -- add some stuff to extending objects.
	def self::extended( object )
		super

		unless object.respond_to?( :log )
			object.extend( Loggability )
			object.log_to( :pushdown )
		end

		object.instance_variable_set( :@pushdown_states, {} )
		object.singleton_class.attr_reader( :pushdown_states )
		object.include( Pushdown::Automaton::InstanceMethods )
	end


	### Generate the pushdown API methods for the pushdown automaton with the given
	### +name+ and install them in the extending +object+.
	def self::install_state_methods( name, object )
		self.log.debug "Installing pushdown methods for %p in %p" % [ name, object ]
		object.attr_reader( "#{name}_stack" )

		# Relies on the above method having already been declared
		state_method = self.generate_state_method( name, object )
		object.define_method( name, &state_method )

		event_method = self.generate_event_method( name, object )
		object.define_method( "handle_#{name}_event", &event_method )

		# update_method = self.generate_update_method( name, object )
		# object.define_method( "update_#{name}", &update_method )

		initial_state_method = self.generate_initial_state_method( name )
		object.define_singleton_method( "initial_#{name}", &initial_state_method )
	end


	### Generate the method used to access the current state object.
	def self::generate_state_method( name, object )
		self.log.debug "Generating current state method for %p: %p" % [ object, name ]
		stack_method = object.instance_method( "#{name}_stack" )
		meth = lambda { stack_method.bind(self).call&.last }

		return meth
	end


	### Generate the external event handler method for the pushdown state named +name+
	### on the specified +object+.
	def self::generate_event_method( name, object )
		self.log.debug "Generating event method for %p: handle_%s_event" % [ object, name ]

		meth = lambda do |event, *args|
			self.call_on_event( name, event, *args )
		end
	end


	### Generate the method that returns the initial state class for a pushdown
	### state named +name+.
	def self::generate_initial_state_method( name )
		self.log.debug "Generating initial state method for %p" % [ name ]
		return lambda do
			config = self.pushdown_states[ name ]
			class_name = config[ :initial_state ]
			return self.pushdown_state_class( name, class_name )
		end
	end


	# A mixin to add instance methods for setting up pushdown states.
	module InstanceMethods

		### Overload the initializer to push the initial state object for any pushdown
		### states.
		def initialize( * )
			super if defined?( super )

			self.class.pushdown_states.each do |name, config|
				self.log.debug "Pushing initial %s" % [ name ]

				state_class = self.class.public_send( "initial_#{name}" ) or
					raise "unset initial_%s while pushing initial state" % [ name ]

				transition = Pushdown::Transition.create( :push, :initial, state_class )
				stack = transition.apply( [] )
				self.instance_variable_set( "@#{name}_stack", stack )
			end
		end


		def call_on_event( name, event, *args )
			stack = self.public_send( "#{name}_stack" )
			current_state = stack.last

			result = current_state.on_event( event, *args )

			if result.is_a?( Symbol )
				transition_name = result
				self.log.debug "Looking up the %p transition for %p" % [ result, current_state ]
				transition_type, state_class_name = current_state.class.transitions[ transition_name ]
				raise "no such transition %p for %s" % [ transition_name, name ] unless transition_type

				result = if state_class_name
						state_class = self.class.pushdown_state_class( name, state_class_name )
						Pushdown::Transition.create( transition_type, transition_name, state_class )
					else
						Pushdown::Transition.create( transition_type, transition_name )
					end
			end

			if result.is_a?( Pushdown::Transition )
				new_stack = result.apply( stack )
				stack.replace( new_stack )
			end

			return result
		end


		# :TODO: Methods that call #update, #on_event, etc. and then manage the
		# application of any transition(s) that are returned.

	end # module InstanceMethods


	### Declare a attribute +name+ which is a pushdown state.
	def pushdown_state( name, initial_state:, states: nil )
		@pushdown_states[ name ] = { initial_state: initial_state, states: states }

		Pushdown::Automaton.install_state_methods( name, self )
	end


	### Return the Class object for the class named +class_name+ of the pushdown state
	### +state_name+.
	def pushdown_state_class( state_name, class_name )
		config = self.pushdown_states[ state_name ] or
			raise "No pushdown state named %p" % [ state_name ]
		states = config[ :states ]

		case states
		when NilClass
			return self.pushdown_inferred_state_class( class_name )
		when Class
			return self.pushdown_pluggable_state_class( states, class_name )
		when Hash
			return states[ class_name ]
		else
			raise "don't know how to derive a state class from %p (%p)" % [ states, states.class ]
		end
	end


	### Return the state class with the name inferred from the given +class_name+.
	def pushdown_inferred_state_class( class_name )
		constant_name = class_name.to_s.capitalize.gsub( /_(\p{Alnum})/ ) do |match|
			match[ 1 ].capitalize
		end
		self.log.debug "Inferred state class for %p is: %s" % [ class_name, constant_name ]

		return self.const_get( constant_name )
	end


	### Derive a state class object named +class_name+ via the (pluggable)
	### +state_base_class+.
	def pushdown_pluggable_state_class( state_base_class, class_name )
		return state_base_class.get_subclass( class_name )
	end

end # module Pushdown::Automaton


