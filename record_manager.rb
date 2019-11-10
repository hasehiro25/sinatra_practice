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
    args[:id] = new_id
    data = fetch_data
    data << args

    output_to_file(data)
  end

  def update(**args)
    data = fetch_data
    data.find { |val| val["id"] == args[:id].to_i }["text"] = args[:text]

    output_to_file(data)
  end

  def delete(id)
    data = fetch_data.reject{ |val| val["id"] == id.to_i}
    output_to_file(data)
  end

  private
    def output_to_file(data)
      File.open(path, "w") do |io|
        JSON.dump(data, io)
      end
    end
end
