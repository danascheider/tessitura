# Boot app from this file. Canto class is defined in canto.rb - 
# this file runs the Thin server.

require_relative 'canto'

Canto.run!