# frozen_string_literal: true

require "json"

class RecordManager
  def self.fetch_data
    @json_data ||= File.open("./data/memo_record.json") do |j|
      JSON.load(j)
    end
  end
end
