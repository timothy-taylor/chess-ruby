# frozen_string_literal: true

require './lib/play'

describe Interface do
  describe '#decode' do
    it 'takes user chess notation and converts it to array coordinates' do
      play = Interface.new
      expect(play.decode('a2')).to eql([6, 0])
    end
  end

  describe '#encode' do
    it 'takes array coordinates and converts to user notation for printing' do
      play = Interface.new
      expect(play.encode([6, 0])).to eql('a2')
    end
  end
end
