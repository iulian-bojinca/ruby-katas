# frozen_string_literal: true

require 'rspec'
require 'rantly'
require 'rantly/rspec_extensions'
require_relative 'multiple_of'

RSpec.describe 'MultipleOf' do
  specify "should be non-negative" do
    property_of {
      integer
    }.check {|number|
      expect(solution(number)).to be >= 0
    }
  end

  specify "should be 0 when negative input" do
    property_of {
      range(Rantly::INTEGER_MIN, -1)
    }.check {|number|
      expect(solution(number)).to eql 0
    }
  end

  describe "unit tests" do
    [
      [10, 23],
      [20, 78],
      [200, 9168],
    ].map {|number, expected_result|
      context "when number is #{number}" do
        subject { solution(number) }

        it {is_expected.to eql expected_result}
      end
    }
  end
end
