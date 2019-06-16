#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/namespace'
require 'popen4'
require 'json/pure'
require 'jq/extend'

set :port, 8080

get '/' do
  data = JSON.parse(File.read("player.json"))
  ant = ""
  data.jq(".#{user}") do |value|
    if !value.nil?
      ant = { "#{user}" => {
        "exp" => "#{value["exp"]}",
        "date" => "#{value["date"]}"
        }
      }
      status 200
    else
      ant = {}
      status 404
    end
  end
  ant.to_json
end

namespace '/api/v1' do
    before do
      content_type 'application/json'
    end

    def json_params
        begin
          JSON.parse(request.body.read)
        rescue
          halt 400, { message:'Invalid JSON' }.to_json
        end
    end


    get '/server/:user' do |user|
      data = JSON.parse(File.read("player.json"))
      ant = ""
      data.jq(".#{user}") do |value|
        if !value.nil?
          ant = { "#{user}" => {
            "exp" => "#{value["exp"]}",
            "date" => "#{value["date"]}"
            }
          }
          status 200
        else
          ant = {}
          status 404
        end
      end
      ant.to_json
    end

    post '/server' do
      'ansible-play playbookfile groupe etc'
    end
end
