require 'capybara/poltergeist'
require 'mini_magick'


Capybara.default_wait_time = 15

module Photograph
  class Artist
    attr_accessor :options
    attr_reader :image

    class MissingUrlError  < ArgumentError; end
    class DeprecationError < RuntimeError;  end

    DefaultOptions  = {
      :x => 0,          # top left position
      :y => 0,
      :w => 1280,       # bottom right position
      :h => 1024,

      :wait => 0.5,     # if selector is nil, wait 1 seconds before taking the screenshot
      :selector => nil  # wait until the selector matches to take the screenshot
    }

    def self.browser
      @browser ||= Capybara::Session.new :poltergeist
    end

    def browser
      @options[:browser] || self.class.browser
    end

    def normalize_url url
      unless url.match(/https?:\/\//)
        url = "http://#{url}"
      end

      url
    end

    def initialize options={}
      raise MissingUrlError.new('missing argument :url') unless options[:url]

      @options = DefaultOptions.merge(options)
      @options[:url] = normalize_url(options[:url])
    end

    def shoot! &block
      raise DeprecationError.new('Using Artist#shoot! without a block had been deprecated') unless block_given?

      browser.visit @options[:url]

      if @options[:selector]
        browser.wait_until do
          browser.has_css? @options[:selector]
        end
      else
        sleep @options[:wait]
      end

      tempfile = Tempfile.new(['photograph','.png'])

      browser.driver.render tempfile.path,
        :width  => options[:w] + options[:x],
        :height => options[:h] + options[:y]

      yield adjust_image(tempfile)
    ensure
      tempfile.unlink if tempfile
    end

    def adjust_image tempfile
      image = MiniMagick::Image.read tempfile

      if options[:h] && options[:w]
        image.crop "#{options[:w]}x#{options[:h]}+#{options[:x]}+#{options[:y]}"
        image.write tempfile
      end

      image
    end
  end
end

