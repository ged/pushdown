# -*- ruby -*-
# frozen_string_literal: true

require 'pluggability'
require 'loggability'

require 'pushdown' unless defined?( Pushdown )


# A componented state object in a Pushdown automaton
class Pushdown::State
	extend Loggability

	# Loggability API -- log to the pushdown logger
	log_to :pushdown

	# Don't allow instantation of the abstract class
	private_class_method :new

	##
	# Allow introspection on declared transitions
	singleton_class.attr_reader :transitions


	### Inheritance callback -- allow subclasses to be instantiated, and add some
	### class-instance data to them.
	def self::inherited( subclass )
		super

		subclass.public_class_method( :new )
		subclass.instance_variable_set( :@transitions, {} )
	end


	#
	# Transition declarations
	#

	### Register a transition +type+ declaration method.
	def self::register_transition( type )
		type = type.to_sym
		meth = lambda do |transition_name, *args|
			self.transitions[ transition_name ] = [ type, *args ]
		end

		method_name = "transition_#{type}"
		define_singleton_method( method_name, &meth )
	end


	#
	# Stack callbacks
	#

	### Stack callback -- called when the state is added to the stack.
	def on_start( state_data )
		return nil # no-op
	end


	### Stack callback -- called when the state is removed from the stack.
	def on_stop( state_data )
		return nil # no-op
	end


	### Stack callback -- called when another state is pushed over this one.
	def on_pause( state_data )
		return nil # no-op
	end


	### Stack callback -- called when another state is popped off from in front of
	### this one, making it the current state.
	def on_resume( state_data )
		return nil # no-op
	end


	#
	# State callbacks
	#

	### State callback -- interval callback called when the state is the current one.
	def update( state_data )
		return nil # no-op
	end


	### State callback -- interval callback called when the state is on the stack,
	### even when the state is not the current one.
	def shadow_update( state_data )
		return nil # no-op
	end


	#
	# Introspection/information
	#

	### Return a description of the State as an engine phrase.
	def description
		return "%#x" % [ self.class.object_id ] unless self.class.name
		return self.class.name.sub( /.*::/, '' ).
			gsub( /([A-Z])([A-Z])/ ) { "#$1 #$2" }.
			gsub( /([a-z])([A-Z])/ ) { "#$1 #$2" }.downcase
	end

end # class Pushdown::State

