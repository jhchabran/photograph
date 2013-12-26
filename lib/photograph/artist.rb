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
      :w => 1280,       # width
      :h => 1024,       # height

      :wait => 0.5,     # if selector is nil, wait 1 seconds before taking the screenshot
      :selector => nil  # wait until the selector matches to take the screenshot
    }

    ##
    # Instanciate a browser instance.
    #
    # Typically it's used to supply a Photograph instance your own browser session,
    # allowing you to reuse it if you're using multiples +Photograph::Artist+
    # instances.
    def self.create_browser
      Capybara::Session.new :poltergeist
    end

    ##
    # Returns current browser instance.
    #
    # If none had been supplied, it creates a new one.
    def browser
      @options[:browser] || self.class.create_browser
    end

    ##
    # Normalize urls, allowing you to use "google.com" instead of "http://google.com"
    def normalize_url url
      unless url.match(/https?:\/\//)
        url = "http://#{url}"
      end

      url
    end

    ##
    # Creates a new +Photograph::Artist+ and configures it through +options+.
    #
    # Cropping is supported through the +x+, +y+, +w+ and +h+ options.
    #
    # Options:
    # * +url+ mandatory, location you want to screenshot
    # * +wait+ wait amount of seconds before screenshotting. *this is option is ignored if +selector+ is provided.
    # * +selector+ wait until the provided +selector+ matches a dom node before screenshotting. Typically faster than an arbritrary +wait+ amount, used when your page has some dynamically inserted nodes.
    # * +x+ top coordinate of the screenshot, default to 0
    # * +y+ left coordinate of the screenshot, default to 0
    # * +w+ width of the screenshot, default to 1280
    # * +h+ height of the screenshot, default to 1024
    def initialize options={}
      raise MissingUrlError.new('missing argument :url') unless options[:url]

      @options = DefaultOptions.merge(options)
      @options[:url] = normalize_url(options[:url])
    end

    ##
    # Takes a screenshot and yield the resulting image.
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

    ##
    # Crops a given +tempfile+ according to initially given +options+
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

