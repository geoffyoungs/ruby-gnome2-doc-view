require "kconv"
require "optparse"
require "rd/rdfmt"
require "rd/visitor"
require "rd/version"
require 'rd/rd2html-lib.rb'
require 'nokogiri'

class BrowseController < ApplicationController
	prepend_before_filter :check_lang

	def index
		path = Rails.root.join('source', @lang, 'text', '*').to_s
		logger.info(path)
		@pages = Dir[path]
	end

	def view
		@path = Rails.root.join('source', @lang, 'text', CGI.escape(params[:id])).to_s

		$Visitor = $Visitor_Class.new()
		#@raw = File.read(@path)
	
		src = IO.readlines(@path).unshift('=begin').push('=end')	
		tree = RD::RDTree.new(src, [File.dirname(@path)], nil)
		$Visitor.lang = @lang
		tree.parse
		@page = $Visitor.visit(tree)
		@title = params[:id]
		@page = Nokogiri.HTML(@page).css('body').inner_html
	end

	def search
	end

	protected
	def check_lang
		if params[:lang]
			set_lang(params[:lang])
		elsif request.session[:lang]
			set_lang(request.session[:lang])
		else
			set_lang(langs.first)
		end
	end

	def langs
		path = Rails.root.join('source')
		@list = Dir.entries(path.to_s).reject do |entry|
			['.', '..', 'hiki'].include? entry
			! path.join(entry).directory?
		end
		if @list.include?('en')
			@list.delete('en')
			@list.unshift('en')
		end
		def langs
			@list
		end
		@list
	end

	def set_lang lang
		if langs.include?(lang)
			request.session[:lang] = lang
			@lang = lang
		else
			request.session[:lang] = langs.first
			@lang = langs.first
		end
	end
end
