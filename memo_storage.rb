# frozen_string_literal: true

require "pg"

class MemoStorage
  DATABASE_NAME = "memoapp"
  TABLE = "memo"

  attr_reader :conn
  def initialize
    @conn = PG.connect(dbname: DATABASE_NAME)
  end

  def all
    conn.exec("SELECT * FROM #{TABLE} ORDER BY id;")
  end

  def find(id)
    conn.prepare("find", "SELECT * FROM #{TABLE} WHERE id=$1;")
    conn.exec_prepared("find", [id])[0]
  end

  def create(text)
    id = new_id
    conn.prepare("insert", "INSERT INTO #{TABLE} VALUES($1, $2);")
    conn.exec_prepared("insert", [id, text])
    find(id)
  end

  def update(id: id, text: text)
    conn.prepare("update", "UPDATE #{TABLE} SET text=$1 WHERE id=$2;")
    conn.exec_prepared("update", [text, id])
  end

  def delete(id)
    conn.prepare("delete", "DELETE FROM #{TABLE} WHERE id=$1;")
    conn.exec_prepared("delete", [id])
  end

  private
    def new_id
      max_id + 1
    end

    def max_id
      res = conn.exec("SELECT max(id) AS id FROM #{TABLE};")
      res.tuple(0)["id"].to_i
    end
end
