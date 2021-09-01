# -*- ruby -*-
# frozen_string_literal: true

require 'loggability'
require 'pluggability'

require 'pushdown' unless defined?( Pushdown )
require 'pushdown/state'


# A transition in a Pushdown automaton
class Pushdown::Transition
	extend Loggability,
		Pluggability

	# Loggability API -- log to the pushdown logger
	log_to :pushdown

	# Pluggability API -- concrete types live in lib/pushdown/transition/
	plugin_prefixes 'pushdown/transition'
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


	### Create a new Transition with the given +name+.
	def initialize( name )
		@name = name
	end


	######
	public
	######

	##
	# The name of the transition; mostly for human consumption
	attr_reader :name


	### Return a state +stack+ after the transition has been applied.
	def apply( stack )
		raise NotImplementedError, "%p doesn't implement required method #%p" %
			[ self.class, __method__ ]
	end


	### Return the transition's type as a lowercase Symbol, such as that specified
	### in transition declarations.
	def type_name
		class_name = self.class.name or return :anonymous
		return class_name.sub( /.*::/, '' ).downcase.to_sym
	end

end # class Pushdown::Transition

