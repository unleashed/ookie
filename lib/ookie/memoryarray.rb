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
  class MemoryArray < String
    attr_reader :pointer, :maxpointer

    def initialize
      @maxpointer = @pointer = 0
      self.<< 0
      super
    end

    def next
      if @pointer == @maxpointer
        self.<< 0
        @maxpointer += 1
      end
      @pointer += 1
    end

    def prev
      @pointer -= 1 unless @pointer == 0
    end

    if RUBY_VERSION =~ /^1\.8/
      alias_method :getbyte, :[]
      alias_method :setbyte, :[]=
    end

    def get
      self.getbyte(@pointer) || 0
    end

    def put(value)
      value = value.ord if value.respond_to? :ord	# make Ruby 1.9 happy
      self.setbyte(@pointer, value || 0)
    end

    def +@
      put(get + 1)
    end

    def -@
      put(get - 1)
    end

  end
end
