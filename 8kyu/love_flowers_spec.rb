# frozen_string_literal: true

require 'rspec'
require 'rantly'
require 'rantly/rspec_extensions'
require_relative 'love_flowers'

RSpec.describe 'love_flowers' do
  describe 'they do not love each other' do
    it 'has flowers with the same petals parity' do
      property_of {
        rand(10).yield_self { |flower1| [flower1, flower1.odd? ? rand(5)*2-1 : rand(5)*2] }
      }.check { |flower1, flower2|
        expect(love_flowers(flower1, flower2)).to be false
      }
    end
  end

  describe 'they love each other' do
    it 'has flowers with different petals parity' do
      property_of {
        rand(10).yield_self { |flower1| [flower1, flower1.odd? ? rand(5)*2 : rand(5)*2-1] }
      }.check { |flower1, flower2|
        expect(love_flowers(flower1, flower2)).to be true
      }
    end
  end
end
