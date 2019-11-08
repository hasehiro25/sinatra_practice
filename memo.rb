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
    RecordManager.new(PATH).fetch_data.map do |memo|
      Memo.new(id: memo["id"].to_i, text: memo["text"])
    end
  end

  def self.find(id)
    record = RecordManager.new(PATH).find(id)
    Memo.new(id: record["id"], text: record["text"])
  end

  def save
    RecordManager.new(PATH).save(id: self.id, text: self.text)
  end

  def update
    RecordManager.new(PATH).update(id: self.id, text: self.text)
  end

  def self.delete(id)
    RecordManager.new(PATH).delete(id)
  end

  def title
    @text.split("\n").first
  end

  private
end
