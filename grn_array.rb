# -*- coding: utf-8 -*-
require 'groonga'
require 'tmpdir'

class GrnArray
  attr_accessor :grn
  include Enumerable

  def self.tmpdb
    Dir.mktmpdir do |dir|
      # p dir
      yield self.new(File.join(dir, "tmp.db"))
    end
  end

  def initialize(path)
    unless File.exist?(path)
      Groonga::Database.create(path: path)
    else
      Groonga::Database.open(path)
    end

    unless Groonga["Array"]
      @grn = Groonga::Array.create(name: "Array", persistent: true) 
      @terms = Groonga::PatriciaTrie.create(name: "Terms", key_normalize: true, default_tokenizer: "TokenBigramSplitSymbolAlphaDigit")
    else
      @grn = Groonga["Array"]
      @terms = Groonga["Terms"]
    end
  end

  def <<(value)
    if @grn.empty?
      value.each do |key, value|
        column = key.to_s
        @grn.define_column(column, "Text") # データ型は"Text"決めうち @todo valueの型種類を元に類推出来るはず
        @terms.define_index_column("array_#{column}", @grn, source: "Array.#{column}", with_position: true)
      end
    end
    
    @grn.add(value)
  end

  def select(query)
    Results.new(@grn.select(query, {default_column: "text"})) # textカラムを検索時のデフォルトカラムとする
  end

  def size
    @grn.size
  end

  def empty?
    size == 0
  end

  def each
    @grn.each do |record|
      yield record
    end
  end

  def [](id)
    raise IndexError if id == 0
    @grn[id]
  end

  def delete(id = nil, &block)
    if block_given?
      @grn.delete(&block)
    else
      raise IndexError if id == 0
      @grn.delete(id)
    end
  end

  class Results
    attr_reader :grn
    include Enumerable

    def initialize(grn)
      @grn = grn
    end

    def each
      @grn.each do |r| 
        yield r
      end
    end

    def size
      @grn.size
    end

    def snippet(tags, options = nil)
      @grn.expression.snippet(tags, options)
    end

    def snippet_text(open_tag = '<<', close_tag = ">>")
      @grn.expression.snippet([[open_tag, close_tag]])
    end

    def snippet_html(open_tag = '<strong>', close_tag = '</strong>')
      @grn.expression.snippet([[open_tag, close_tag]], {html_escape: true})
    end
  end

  # その内...
  def clear
  end
  
end

