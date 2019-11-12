# frozen_string_literal: true

require "json"

class RecordManager
  def initialize(path)
    @path = path
  end

  def fetch_data
    return [] unless File.exist?(path)
    File.open(path) do |file|
      file.flock(File::LOCK_EX)
      JSON.load(file)
    end
  end

  def find(id)
    fetch_data.find { |hash| hash["id"].to_i == id }
  end

  def new_id(data)
    return 1 if !File.exist?(path) || data.empty?
    max_id(data) + 1
  end

  def save(**args)
    output_to_file_with_id(args)
    args
  end

  def update(**args)
    update_file(args)
  end

  def delete(id)
    data = fetch_data.reject { |val| val["id"] == id.to_i }
    output_to_file(data)
  end

  private
    attr_accessor :path

    def output_to_file_with_id(args)
      File.open(path, "r+") do |file|
        file.flock(File::LOCK_EX)
        data = JSON.load(file)
        args[:id] = new_id(data)
        data << args
        file.seek(0)
        JSON.dump(data, file)
      end
    end

    def update_file(args)
      File.open(path, "r+") do |file|
        file.flock(File::LOCK_EX)
        data = JSON.load(file)
        record = data.find { |val| val["id"] == args[:id].to_i }
        args.delete(:id)
        file.seek(0)
        args.each do |key, val|
          record[key.to_s] = val
        end
        JSON.dump(data, file)
      end
    end

    

    def max_id(data)
      data.max_by { |val| val["id"].to_i }["id"].to_i
    end
end
