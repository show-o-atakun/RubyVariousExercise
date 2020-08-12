require 'rubygems'
require 'ramaze'

class MainController < Ramaze::Controller
  map '/'

  def hello
    "Hello, world!"
  end
end

Ramaze.start :port => 7000