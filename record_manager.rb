# frozen_string_literal: true

require "json"

class RecordManager
  attr_accessor :path

  def initialize(path)
    @path = path
  end

  def fetch_data
    File.open(path) do |j|
      JSON.load(j)
    end
  end

  def find(id)
    fetch_data.find{ |hash| hash["id"].to_i == id}
  end

  def new_id
    fetch_data.max_by{ |val| val["id"].to_i }["id"].to_i + 1
  end

  def save(**args)
    args[:id] = new_id if args[:id].nil?
    arr = fetch_data
    arr << args

    File.open(path, 'w') do |io|
      JSON.dump(arr, io)
    end
  end

  def update(**args)
    data = fetch_data
    data.find { |val| val["id"] == args[:id].to_i }["text"] = args[:text]

    File.open(path, 'w') do |io|
      JSON.dump(data, io)
    end
  end

  def delete(id)
    data = fetch_data.reject{ |val| val["id"] == id.to_i}

    File.open(path, 'w') do |io|
      JSON.dump(data, io)
    end
  end
end
