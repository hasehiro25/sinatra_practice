# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "./memo"

get "/memos" do
  memos = Memo.all
  erb :index, locals: {memos: memos}
end

get "/memos/:id" do |id|
  "horray #{id}"
end
