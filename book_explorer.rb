#!/bin/ruby

require 'rubygems'
require 'awesome_print'


dir = "/Users/aechavez/scripts"

def traverse_directory(dir)
  item            = Hash.new
  traversal_paths = Array.new
  
  value = %x( ls -alh \ #{dir} | tail -n +4).split(/\n/)

  value.each do |line|

    object = dir + "/" + line.split[8]
    puts "Evalutaing #{object}"

    unless line.split[8] == "." || line.split[8] == ".."

      item["#{object}"] = Hash.new 
      item["#{object}"]['filename']        =  line.split[8]
 
      item["#{object}"]["updated"]        =  line.split[5] + " " + line.split[6] + " " + line.split[7]
      item["#{object}"]["permissions"] =  line.split[0]
      item["#{object}"]["owner"]       =  line.split[2] 
      item["#{object}"]["group"]       =  line.split[3]
      item["#{object}"]["type"] 	=  line.split[0].chars.first
      item["#{object}"]["absolute_path"]   = object

      calculated_size = %x( du #{item[object]['absolute_path']}).split[0]
      item["#{object}"]["calculated_size"] = calculated_size

      if item["#{object}"]["type"] == "d"
        traversal_paths.push(item["#{object}"]['absolute_path'])
      end
    end  
  end
  ap item
  return traversal_paths
end


dirs = traverse_directory(dir)

ap dirs

#ap traverse_directory("/Users/aechavez/scripts/book_explorer/2015-11-17/P10795947")

dirs.each do |folder|
  ap traverse_directory(folder)
end
