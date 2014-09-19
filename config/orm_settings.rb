Dir.glob("../models/*") {|file| require file }

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps