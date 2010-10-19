# Ookie Ook! language interpreter - http://ook.heroku.com
#
# Copyright (c) 2010 Alejandro Martinez Ruiz <alex at@ flawedcode dot. org>
# See LICENSE.txt for licensing terms.
#
# Language info at http://www.dangermouse.net/esoteric/ook.html
#
# Ookie.run 'Ook. Ook! Ook! Ook? Ook! Ook. Ook! Ook! Ook? Ook!'
#

module Ookie
  module Version
    MAJOR = 0
    MINOR = 2
    PATCH = 1
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')
  end
end
