# frozen_string_literal: true

require "./record_manager"

class Memo
  PATH = "./data/memo_record.json"

  attr_accessor :id, :text

  def initialize(id: nil, text:)
    @id = id
    @text = text
  end

  def self.all
    record_manager.fetch_data.map do |memo|
      Memo.new(id: memo["id"].to_i, text: memo["text"])
    end
  end

  def self.find(id)
    record = record_manager.find(id)
    Memo.new(id: record["id"], text: record["text"])
  end

  def save
    record_manager.save(id: self.id, text: self.text)
  end

  def update
    record_manager.update(id: self.id, text: self.text)
  end

  def self.delete(id)
    record_manager.delete(id)
  end

  def title
    @text.split("\n").first
  end

  private
    def self.record_manager
      RecordManager.new(PATH)
    end

    def record_manager
      @record_manager ||= Memo.record_manager
    end
end
