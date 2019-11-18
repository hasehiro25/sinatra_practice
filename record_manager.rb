# frozen_string_literal: true

require "json"

class RecordManager
  def initialize(path)
    @path = path
  end

  def fetch_data
    check_file
    File.open(path) do |file|
      file.flock(File::LOCK_EX)
      JSON.load(file)
    end
  end

  def find(id)
    fetch_data.find { |hash| hash["id"] == id }
  end

  def save(**args)
    overwrite_file do |data|
      args[:id] = new_id(data)
      data << args
    end
    args
  end

  def update(**args)
    overwrite_file do |data|
      record = data.find { |val| val["id"] == args[:id].to_i }
      args.delete(:id)
      args.each do |key, val|
        record[key.to_s] = val
      end
    end
  end

  def delete(id)
    overwrite_file { |data| data.delete_if { |val| val["id"] == id.to_i } }
  end

  private
    attr_accessor :path

    def check_file
      create_file unless File.exist?(path)
      create_array if File.zero?(path)
    end

    def create_file
      File.open(path, "w") do |file|
        file.write("[]")
      end
    end

    def create_array
      File.write(path, "[]")
    end

    def overwrite_file
      check_file
      File.open(path, "r+") do |file|
        file.flock(File::LOCK_EX)
        data = JSON.load(file)
        yield(data)
        file.seek(0)
        file.truncate(0)
        JSON.dump(data, file)
      end
    end

    def new_id(data)
      return 1 if data.empty?
      max_id(data) + 1
    end

    def max_id(data)
      data.max_by { |val| val["id"].to_i }["id"].to_i
    end
end
