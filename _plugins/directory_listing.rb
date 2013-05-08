# Title: Directory Listing Plugin for Jekyll
# Author: Simon Heimlicher http://simon.heimlicher.com
# Description: Display list of pages and directories beneath current directory
# Configuration: You can set default title in _config.yml as follows:
#    directory_listing_title: "Contents: "
#    directory_listing_prefix: "Contents of "
#
# Syntax {% directory_listing Title of Listing %}
#
# Example 1:
# {% directory_listing Further reading: %}
#

require File.dirname(__FILE__) + '/raw'
require 'pathname'

module Jekyll
  class Page
    def source_path
      # File.join(@dir, @name).gsub(/^\/*/,'')
      File.join(@dir, @name).sub(%r{^/*}, '')
    end

    def parent
      @dir.sub(%r{^/*}, '')
      @dir.sub(%r{[^/]*$}, '')
    end
  end
  class IncludeListingTag < Liquid::Tag
    include TemplateWrapper

    def initialize(tag_name, markup, tokens)
      @title = nil
      @file = nil
      if markup.strip =~ /\s*lang:(\w+)/i
        @filetype = $1
        markup = markup.strip.sub(/lang:\w+/i, '')
      end
      if markup.strip =~ /(.*)?(\s+|^)(\/*\S+)/i
        @title = $1 || nil
        @file = $3
      end
      super
    end

    def add_item(page)
      title = page
      source_file = File.join(page)
      if File.exists?(source_file)
        content = File.read(source_file, :encoding => Encoding::ASCII_8BIT) rescue content = "<#{page}>"

        if content =~ /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
          content = $POSTMATCH
          begin
            data = YAML.load($1)
          rescue => e
            puts "YAML Exception reading #{name}: #{e.message}"
          end
        end

        if data && data['title']
          title = data['title']
        end
      else
        puts "File not found: #{source_file}"
      end
      s = "<li><a href=\"#{page}\">#{title}</a></li>"
    rescue Exception
      "Exception: #{$!}"
      puts $!
      puts $!.backtrace
    end

    def render(context)
      site = context.registers[:site]
      @source = site.source
      @page = context.environments.first['page']
      @title = @page['title']
      @url = @page['url']
      @dir = @url.sub(%r{\A(.*?/)[^/]*\z}, '\1')
      @title ||= (context.registers[:site].config['directory_listing_title'] ||
          context.registers[:site].config['directory_listing_prefix']+@dir || @dir)
      html = '<ul>'
      Dir.chdir("#{@source}/#{@dir}") do
        Dir['*'].each do |page|
          next if "#{@dir}#{page}" == @page['url']
          if true # page.index?
            html += self.add_item(page)
          elsif page.parent == @dir
            html += self.add_item(page)
          end
        end
        html += '</ul>'
        html
      end
    end
  end
end

Liquid::Template.register_tag('directory_listing', Jekyll::IncludeListingTag)
