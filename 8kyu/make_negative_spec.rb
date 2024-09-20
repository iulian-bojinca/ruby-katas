# frozen_string_literal: true

require 'rspec'
require 'rantly'
require 'rantly/rspec_extensions'
require_relative 'make_negative'

RSpec.describe 'make_negative' do
  specify "should always output a negative number" do
    property_of {
      Enumerator.new { |y| loop { y << integer(-1000..1000) } }.lazy.reject(&:zero?).first
    }.check { |number|
      expect(make_negative(number).negative?).to be true
    }
  end

  specify "should return  0 when number is 0" do
    expect(make_negative(0)).to eql 0
  end

  specify "should be idempotent" do
    property_of {
      rand(10)
        .times
        .reduce(make_negative(integer)) { |acc, _| make_negative(acc) }
    }.check { |number_applied|
      expect(make_negative(number_applied)).to eql(number_applied)
    }
  end


end
