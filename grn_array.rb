# -*- coding: utf-8 -*-
require 'groonga'
require 'tmpdir'

class GrnArray
  include Enumerable

  def self.tmpdb
    Dir.mktmpdir do |dir|
      yield FullTextSearchArray.new(File.join(dir, "tmp.db"))
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

  def each
    @grn.each do |record|
      yield record
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

    def snippet_html(open_tag = '<strong>', close_tag = "</strong>")
      @grn.expression.snippet([[open_tag, close_tag]], {html_escape: true})
    end
  end

  # その内...

  def []
  end

  def []=
  end


  def clear
  end
end

