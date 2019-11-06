# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "./memo"

get "/memos" do
  memos = Memo.all
  erb :index, locals: {memos: memos}
end

get "/memos/:id" do |id|
  memo = Memo.find(id.to_i)
  erb :show, locals: { memo: memo }
end
