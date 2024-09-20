# frozen_string_literal: true

require 'rspec'
require 'rantly'
require 'rantly/rspec_extensions'
require_relative 'walk_app'


describe 'is_valid_walk' do
  describe "property based tests" do
    STEPS_LIMIT = 10

    specify 'when valid 10 steps walk' do
      property_of {
        sized(STEPS_LIMIT) {
          Enumerator
            .new {|y| loop { y << array { %w[n w s e].sample } } }
            .lazy
            .select {|arr| arr.count('n') == arr.count('s') && arr.count('w') == arr.count('e')}
            .first
        }
      }.check {|walk| expect(is_valid_walk(walk)).to be true }
    end

    specify 'when not returning back in 10 steps' do
      property_of {
        sized(STEPS_LIMIT) {
          Enumerator
            .new {|y| loop { y << array { %w[n w s e].sample } } }
            .lazy
            .select {|arr| arr.count('n') != arr.count('s') || arr.count('w') != arr.count('e')}
            .first
        }
      }.check {|walk|
          expect(is_valid_walk(walk)).to be false
      }
    end

    specify "when walks are less than #{STEPS_LIMIT} steps" do
      property_of {
        sized(range(0, STEPS_LIMIT - rand(1..9))) { array { %w[n w s e].sample }}
      }.check { |walk|
        expect(is_valid_walk(walk)).to be false
      }
    end

    specify "when walks are more than #{STEPS_LIMIT} steps" do
      property_of {
        sized(STEPS_LIMIT + rand(1..9)) { array { %w[n w s e].sample }}
      }.check { |walk|
        expect(is_valid_walk(walk)).to be false
      }
    end
  end

  describe "explicit unit tests" do
    [
      ['walking back and forward', %w[n s n s n s n s n s], true],
      ['circling back', %w[n n n n e s s s s w], true],
      ['walking too many steps', %w[w e w e w e w e w e w e], false],
      ['walking too few steps', ['w'], false],
      ['going to far', %w[n n n s n s n s n s], false]
    ].map {|scenario, input, expected_result|
      context "when #{scenario}" do
        subject { is_valid_walk(input) }

        it { is_expected.to be expected_result }
      end
    }
  end
end
