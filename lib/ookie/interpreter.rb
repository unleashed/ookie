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
  class Interpreter
    RE_OOK_CODE = /\s*(Ook[!?\.])\s*/

    CodeInfo		= Class.new(StandardError)
    EndOfInstructions 	= Class.new(CodeInfo)

    CodeError		= Class.new(StandardError)
    UnmatchedStartLoop	= Class.new(CodeError)
    UnmatchedEndLoop	= Class.new(CodeError)
    NoOokCode		= Class.new(CodeError)
    OddNumberOfOoks	= Class.new(CodeError)

    attr_reader :ooks, :mem, :pc, :loops
    attr_writer :verbose
    attr_accessor :code, :ifd, :ofd, :efd

    def verbose(msg = nil)
      @efd.puts "#{self.class}: #{msg}" if @verbose and msg
      @verbose
    end

    def initialize(code = '', ifd = STDIN, ofd = STDOUT, efd = STDERR)
      @verbose = false
      @code, @ifd, @ofd, @efd = code, ifd, ofd, efd
      reset!
    end

    def reset!
      @pc = 0
      @loops = []
      @mem = MemoryArray.new
    end

    def self.run(code)
      new.run(code)
    end

    def run(code = nil)
      @code = code if code
      parse
      loop { stepi }
    rescue EndOfInstructions
      verbose 'program finished correctly'
    end

    def stepi
      insn = next_insn
      if insn.empty?
        raise UnmatchedStartLoop unless @loops.empty?
        raise EndOfInstructions
      end
      send insn
      @pc += 1
    end

    protected

    def ookd_ookq
      verbose 'move pointer forward'
      @mem.next
    end

    def ookq_ookd
      verbose 'move pointer backward'
      @mem.prev
    end

    def ookd_ookd
      verbose 'increment pointer cell'
      +@mem
    end

    def ookx_ookx
      verbose 'decrement pointer cell'
      -@mem
    end

    def ookd_ookx
      verbose 'now reading input'
      @mem.put(@ifd.read(1))
    end

    def ookx_ookd
      verbose 'now writing output'
      @ofd.write @mem.get.chr
    end

    def ookx_ookq
      verbose 'evaluating start loop'
      if @mem.get == 0
        verbose "loop skipped: #@pc"
        skip_loop
      else
        verbose "loop entered: #@pc, loops: #{@loops.join ', '}"
        @loops.push @pc
      end
    end

    def ookq_ookx
      verbose 'evaluating end loop'
      raise UnmatchedEndLoop unless @loops.last
      @mem.get != 0 ? @pc = @loops.last : @loops.pop
    end

    private

    def skip_loop
      nesting = 1
      loop do
        @pc += 1
        insn = next_insn
        raise UnmatchedStartLoop if insn.empty?
        if insn == 'ookq_ookx'
          nesting -= 1
          break if nesting == 0
        elsif insn == 'ookx_ookq'
          nesting += 1
        end
      end
    end

    def parse
      @ooks = @code.scan(RE_OOK_CODE).flatten
      raise NoOokCode if @ooks.empty?
      raise OddNumberOfOoks if @ooks.size.odd?
    end

    def next_insn
      @ooks.slice(@pc*2, 2).join('_').downcase.gsub('!', 'x').gsub('?','q').gsub('.','d')
    rescue NoMethodError	# happens when last instruction is an end loop
      ''
    end
  end
end
