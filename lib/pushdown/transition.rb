# -*- ruby -*-
# frozen_string_literal: true

require 'loggability'
require 'pluggability'

require 'pushdown' unless defined?( Pushdown )

# pub enum Trans<T, E> {
#     /// Continue as normal.
#     None,
#     /// Remove the active state and resume the next state on the stack or stop
#     /// if there are none.
#     Pop,
#     /// Pause the active state and push a new state onto the stack.
#     Push(Box<dyn State<T, E>>),
#     /// Remove the current state on the stack and insert a different one.
#     Switch(Box<dyn State<T, E>>),
#     /// Remove all states on the stack and insert a different one.
#     Replace(Box<dyn State<T, E>>),
#     /// Remove all states on the stack and insert new stack.
#     NewStack(Vec<Box<dyn State<T, E>>>),
#     /// Execute a series of Trans's.
#     Sequence(Vec<Trans<T, E>>),
#     /// Stop and remove all states and shut down the engine.
#     Quit,
# }

# A transition in a Pushdown automaton
class Pushdown::Transition
	extend Loggability,
		Pluggability

	# Loggability API -- log to the pushdown logger
	log_to :pushdown

	# Pluggability API -- concrete types live in lib/pushdown/transition/
	plugin_prefixes 'pushdown/transition/'
	plugin_exclusions 'spec/**/*'


	# Don't allow direct instantiation (abstract class)
	private_class_method :new


	### Inheritance hook -- enable instantiation.
	def self::inherited( subclass )
		super
		subclass.public_class_method( :new )
		if (( type_name = subclass.name&.sub( /.*::/, '' )&.downcase ))
			Pushdown::State.register_transition( type_name )
		end
	end


	### Create a new Transition with the given +name+ and +args+.
	def initialize( name, *args )
		@name = name
		@args = args
	end


	######
	public
	######

	##
	# The name of the transition; mostly for human consumption
	attr_reader :name

	##
	# Arguments given when the transition is created. This can be used to pass
	# values between States.
	attr_reader :args


	### Return a state +stack+ after the transition has been applied. 
	def apply( stack )
		raise NotImplementedError, "%p doesn't implement required method #%p" %
			[ self.class, __method__ ]
	end

end # class Pushdown::Transition

