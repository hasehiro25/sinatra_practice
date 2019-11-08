# frozen_string_literal: true

require "json"

class RecordManager
  PATH = "./data/memo_record.json"

  def self.fetch_data
    File.open(PATH) do |j|
      JSON.load(j)
    end
  end

  def self.find(id)
    fetch_data.find{ |hash| hash["id"].to_i == id}
  end

  def self.new_id
    fetch_data.max_by{ |val| val["id"].to_i }["id"].to_i + 1
  end

  def self.save(**args)
    args[:id] = new_id if args[:id].nil?
    arr = fetch_data
    arr << args

    File.open(PATH, 'w') do |io|
      JSON.dump(arr, io)
    end
  end

  def self.update(**args)
    data = fetch_data
    data.find{ |val| val["id"] == args[:id].to_i}["text"] = args[:text]

    File.open(PATH, 'w') do |io|
      JSON.dump(data, io)
    end
  end
end
