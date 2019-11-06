# frozen_string_literal: true

require "json"

class RecordManager
  PATH = "./data/memo_record.json"

  def self.fetch_data
    File.open(PATH) do |j|
      JSON.load(j)
    end
  end

  def self.new_id
    fetch_data.max_by { |val| val["id"].to_i }["id"].to_i + 1
  end

  def self.save(id, text)
    arr = fetch_data
    new_data = { id: id, text: text}
    arr << new_data
    p arr

    File.open(PATH, 'w') do |io|
      JSON.dump(arr, io)
    end
  end
end
