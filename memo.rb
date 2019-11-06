# frozen_string_literal: true

require './record_manager'

class Memo
  attr_accessor :id, :text

  def initialize(id, text)
    @id = id
    @text = text
  end

  def self.all
    memos
  end

  def self.find(id)
    memos.find { |memo| memo.id == id }
  end

  def title
    @text.split("\n").first
  end

  private
    def self.memos
      @memos ||= RecordManager.fetch_data.map do |memo|
        Memo.new(memo["id"].to_i, memo["text"])
      end
    end
end
