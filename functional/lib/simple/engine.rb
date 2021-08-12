# -*- ruby -*-
# frozen_string_literal: true

require 'pushdown'
require 'simple' unless defined?( Simple )

class Simple::Engine
	extend Pushdown::Automaton

	pushdown_state :state,
		initial_state: :off

	def inspect
		return "#<Simple::Engine:%#x state: %s>" % [ self.object_id, self.state.description ]
	end


	class Off < Pushdown::State
		transition_push :start, :starting

		def on_event( event )
			return transition( :start ) if event == :start
			return nil
		end
	end


	class Starting < Pushdown::State
		tramsition_switch :started, :running
		transition_pop :didnt_start

		def initialize
			@started_cranking = Time.now
		end

		def update( * )
			if rand( 1.0 ) > 0.8
				return transition( :started )
			elsif Time.now - @started_cranking > 5
				return transition( :didnt_start )
			end
			return nil
		end
	end


	class Running < Pushdown::State
		transition_replace :stop, :off

		def on_event( event )
			return transition( :stop ) if event == :stop
			return nil
		end
	end

end # class Simple::Engine


if $0 == __FILE__
	engine = Simple::Engine.new
	p engine
	engine.handle_state_event( :start )
	Timer.new( 10 ) { engine.update_state( state_data ) }
	p engine
end