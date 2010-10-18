# Ookie Ook! language interpreter - http://ook.heroku.com
#
# Copyright (c) 2010 Alejandro Martinez Ruiz <alex at@ flawedcode dot. org>
# See LICENSE.txt for licensing terms.
#
# Language info at http://www.dangermouse.net/esoteric/ook.html
#
# Ookie.run 'Ook. Ook! Ook! Ook? Ook! Ook. Ook! Ook! Ook? Ook!'
#

require 'ookie/memoryarray'
require 'ookie/interpreter'

module Ookie
  VERSION = '0.2.0'

  def self.run(*args)
    Interpreter.run(*args)
  end
end
