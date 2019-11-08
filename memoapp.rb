# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "./memo"

enable :method_override

get "/memos" do
  memos = Memo.all
  erb :index, locals: {memos: memos}
end

get "/memos/new" do
  erb :new
end

get "/memos/:id" do |id|
  memo = Memo.find(id.to_i)
  erb :show, locals: { memo: memo }
end

post "/memos" do
  text = Memo.new(text: params["text"])
  text.save
  redirect to "/memos"
end

get "/memos/:id/edit" do |id|
  memo = Memo.find(id.to_i)
  erb :edit, locals: {memo: memo}
end

put "/memos/:id" do
  text = Memo.new(id: params[:id], text: params[:text])
  text.update
  redirect to "/memos"
end

delete "/memos/:id" do
  Memo.delete(params["id"])
  redirect to "/memos"
end
