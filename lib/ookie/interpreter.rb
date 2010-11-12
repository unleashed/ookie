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
    RE_BFK_CODE = /\s*([<>\+-\.,\[\]])\s*/

    CodeInfo		= Class.new(StandardError)
    EndOfInstructions 	= Class.new(CodeInfo)

    CodeError		= Class.new(StandardError)
    NoCode		= Class.new(CodeError)
    UnmatchedStartLoop	= Class.new(CodeError)
    UnmatchedEndLoop	= Class.new(CodeError)

    OokCodeError	= Class.new(StandardError)
    OddNumberOfOoks	= Class.new(OokCodeError)

    attr_reader :ooks, :mem, :pc, :loops
    attr_writer :verbose
    attr_accessor :code, :ifd, :ofd, :efd, :lang, :optimize

    def verbose(msg = nil)
      @efd.puts "#{self.class}: #{msg}" if @verbose and msg
      @verbose
    end

    def initialize(code = '', ifd = STDIN, ofd = STDOUT, efd = STDERR)
      @verbose = false
      @code, @ifd, @ofd, @efd = code, ifd, ofd, efd
      @lang = :ook
      @optimize = true
      reset!
    end

    def reset!
      @pc = 0
      @loops = []
      @mem = MemoryArray.new
    end

    def self.run(code, lang = :ook)
      new.run(code, lang)
    end

    def run(code = nil, lang = nil)
      @code = code if code
      @lang = lang if lang
      send("parse_#@lang")
      loop { stepi }
    rescue EndOfInstructions
      verbose 'program finished correctly'
    end

    def stepi
      insn = next_insn
      if insn.nil?
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

    def next_insn
      @ooks[@pc]
    end

    def skip_loop
      nesting = 1
      loop do
        @pc += 1
        insn = next_insn
        raise UnmatchedStartLoop if not insn or insn.empty?
        if insn == 'ookq_ookx'
          nesting -= 1
          break if nesting == 0
        elsif insn == 'ookx_ookq'
          nesting += 1
        end
      end
    end

    def parse_helper(re)
      @ooks = @code.scan(re).flatten
      raise NoCode if @ooks.empty?
      @ooks = yield
      optimize! if @optimize
    end

    def parse_ook
      parse_helper(RE_OOK_CODE) do
        raise OddNumberOfOoks if @ooks.size.odd?
        @ooks.each_slice(2).entries.collect! do |o|
          o.join('_').downcase.gsub('!', 'x').gsub('?', 'q').gsub('.', 'd')
        end
      end
    end

    def parse_bfk
      parse_helper(RE_BFK_CODE) do
        @ooks.collect! do |b|
          case b
          when '>' then 'ookd_ookq'
          when '<' then 'ookq_ookd'
          when '+' then 'ookd_ookd'
          when '-' then 'ookx_ookx'
          when '.' then 'ookx_ookd'
          when ',' then 'ookd_ookx'
          when '[' then 'ookx_ookq'
          else 'ookq_ookx'
          end
        end
      end
    end

    def optimize!
      verbose "original code size = #{@ooks.size}"
      optimize_helper([:optimize_nils])
      verbose "optimized code size = #{@ooks.size}"
    end

    def optimize_helper(rules)
      i = 0
      while @ooks[i]  do
        if rules.find { |r| send(r, @ooks[i], @ooks[i+1]) }
          @ooks[i, 2] = []
          i -= 1 unless i == 0
        else
          i += 1
        end
      end
    end

    def optimize_nils(i, j)
      # this takes away innocuous operations, such as move right and then left
      ops = [[i, j], [j, i]]
      ops.include?(['ookd_ookq', 'ookq_ookd']) or
        ops.include?(['ookd_ookd', 'ookx_ookx'])
    end

  end
end
