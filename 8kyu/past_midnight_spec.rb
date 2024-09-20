# frozen_string_literal: true

require 'rspec'
require 'rantly'
require 'rantly/rspec_extensions'
require_relative 'past_midnight'

RSpec.describe 'past_midnight' do
  specify "should check for properties" do
    property_of {
      [range(0, 23), range(0, 59), range(0, 59)]
    }.check {|h, m, s|
      result = past_midnight(h, m, s)

      expect(result).to be_a(Integer)
      expect(result).to be >= 0
      expect(result%1000).to eql 0
    }
  end

  describe "explicit edge cases" do
    [
      [0,0,0, 0],
      [23,59,59, 86399000]
    ].map {|h, m, s, expected_result|
      context "when time is #{h}:#{m}:#{s}" do
        subject { past_midnight(h, m, s) }
        it {is_expected.to eql expected_result}
      end
    }
  end
end
