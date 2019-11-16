# frozen_string_literal: true

require "pg"

class MemoStorage
  DATABASE_NAME = "memoapp"

  attr_reader :conn
  def initialize
    @conn = PG.connect(dbname: DATABASE_NAME)
  end

  def all
    conn.exec("SELECT * FROM memo ORDER BY id").to_a
  end

  def find(id)
    conn.exec("SELECT * FROM memo WHERE id=#{id}")[0]
  end

  def create(text)
    id = new_id
    value = "#{id}, \'#{text}\'"
    conn.exec("INSERT INTO memo(id, text) VALUES (#{value})")
    find(id)
  end

  def update(id: id, text: text)
    conn.exec("UPDATE memo SET text=\'#{text}\' WHERE id=#{id}")
  end

  def delete(id)
    conn.exec("DELETE FROM memo WHERE id=#{id}")
  end

  private
    def new_id
      max_id + 1
    end

    def max_id
      res = conn.exec("SELECT max(id) AS id FROM memo;")
      res.tuple(0)["id"].to_i
    end
end
