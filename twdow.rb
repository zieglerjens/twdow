#!/usr/bin/env ruby

require 'json/pure'
require 'jq/extend'
require 'time'

filename = "player.json"
exit = false
puts("Usage: First type in username or 'exit' to leave. Second input is the EXP from the user if username is given.")

FileUtils.cp filename, "#{filename}.bak"

while !exit
  print "User: "
  user = gets.chomp

  if user == "exit"
    exit = true
  else
    time = Time.now.getlocal
    time = time.strftime("%d.%m.%Y")

    data = JSON.parse(File.read(filename))
    data.jq(".#{user}") do |value|
      if !value.nil?
        puts("Vorhanden: #{user} hat #{value["exp"]} exp am #{value["date"]}")
        print "EXP: "
        exp = gets.chomp
        if exp == "exit"
          exit = true
        else
          if value["exp"] != exp
            data["#{user}"]["exp"] = exp
            data["#{user}"]["date"] = time
            puts("Neu: #{user} hat #{exp} exp am #{time}")
          end
        end
      else
        puts("User muss neu angelegt werden")
        print "EXP: "
        exp = gets.chomp
        if exp == "exit"
          exit = true
        else
          data.merge!(
            "#{user}": {
              "exp": "#{exp}",
              "date": "#{time}"
            }
          )
          puts("Neu: #{user} hat #{exp} exp am #{time}")
        end
      end
      File.write(filename,data.to_json)
    end
  end
end
