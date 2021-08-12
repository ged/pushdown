# -*- ruby -*-
# frozen_string_literal: true

require_relative 'spec_helper'

require 'rspec'
require 'pushdown'


RSpec.describe( Pushdown ) do

	it "has a semantic version" do
		expect( described_class::VERSION ).to match( /\A\d+(\.\d+){2}/ )
	end

end

