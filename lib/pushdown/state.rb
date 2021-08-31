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

		method_name = "transition_%s" % [ type ]
		self.log.info "Setting up transition declaration method %p" % [ method_name ]
		define_singleton_method( method_name, &meth )
	end


	#
	# Stack callbacks
	#

	### Stack callback -- called when the state is added to the stack.
	def on_start( data=nil )
		return nil # no-op
	end


	### Stack callback -- called when the state is removed from the stack.
	def on_stop( data=nil )
		return nil # no-op
	end


	### Stack callback -- called when another state is pushed over this one.
	def on_pause( data=nil )
		return nil # no-op
	end


	### Stack callback -- called when another state is popped off from in front of
	### this one, making it the current state.
	def on_resume( data=nil )
		return nil # no-op
	end


	#
	# Event callbacks
	#

	### Event callback -- called by the automaton when its #on_<stackname>_event method
	### is called. This method can return a Transition or a Symbol which maps to one.
	def on_event( event )
		return nil # no-op
	end


	#
	# Interval callbacks
	#

	### State callback -- interval callback called when the state is the current
	### one. This method can return a Transition or a Symbol which maps to one.
	def update( *data )
		return nil # no-op
	end


	### State callback -- interval callback called when the state is on the stack,
	### even when the state is not the current one.
	def shadow_update( *data )
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


	### Create a new instance of Pushdown::Transition named +transition_name+ that
	### has been declared using one of the Transition Declaration methods.
	def transition( transition_name, automaton, stack_name )
		self.log.debug "Looking up the %p transition for %p via %p" %
			[ transition_name, self, automaton ]

		transition_type, state_class_name = self.class.transitions[ transition_name ]
		raise "no such transition %p for %p" % [ transition_name, self.class ] unless transition_type

		if state_class_name
			state_class = automaton.class.pushdown_state_class( stack_name, state_class_name )
			return Pushdown::Transition.create( transition_type, transition_name, state_class )
		else
			return Pushdown::Transition.create( transition_type, transition_name )
		end
	end

end # class Pushdown::State

