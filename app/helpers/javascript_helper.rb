require 'sinatra/base'

module Sinatra
  module JavaScriptHelper
    def javascript(url)
      "<script src='#{url}'></script>"
    end
  end

  helpers JavaScriptHelper
end