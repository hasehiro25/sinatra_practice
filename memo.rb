# frozen_string_literal: true

require './record_manager'

class Memo
  attr_accessor :id, :text

  def initialize(id: nil, text:)
    @id = id
    @text = text
  end

  def self.all
    memos
  end

  def self.find(id)
    record = RecordManager.find(id)
    Memo.new(id: record["id"], text: record["text"])
  end

  def save
    RecordManager.save(RecordManager.new_id, self.text)
  end

  def title
    @text.split("\n").first
  end

  private
    def self.memos
      RecordManager.fetch_data.map do |memo|
        Memo.new(id: memo["id"].to_i, text: memo["text"])
      end
    end
end
