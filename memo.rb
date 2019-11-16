# frozen_string_literal: true

require "./memo_storage"

class Memo
  attr_accessor :id, :text

  def initialize(id: nil, text:)
    @id = id
    @text = text
  end

  def self.all
    storage.all.map do |memo|
      Memo.new(id: memo["id"].to_i, text: memo["text"])
    end
  end

  def self.find(id)
    record = storage.find(id)
    Memo.new(id: record["id"].to_i, text: record["text"])
    rescue NoMethodError => e
      puts e
      raise Sinatra::NotFound
  end

  def save
    saved_record = storage.create(self.text)
    self.id = saved_record["id"]
  end

  def update
    storage.update(id: self.id, text: self.text)
  end

  def self.delete(id)
    storage.delete(id)
  end

  def title
    text.split("\r\n").first
  end

  private
    def self.storage
      MemoStorage.new
    end

    def storage
      @storage ||= Memo.storage
    end
end
