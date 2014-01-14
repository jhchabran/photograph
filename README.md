# Photograph

Photograph allows to take screenshots of webpages, the rendering being
done by webkit thanks to [PhantomJS](http://phantomjs.org/) and [Poltergeist](https://github.com/jonleighton/poltergeist).

Typically, this can be used to generate previews for DOM based
documents.

Please remind that having a webkit instance doing the rendering, even if it is launched only once then reused, is slow, around 600ms!

## Installation

PhantomJS is required and must be available in your path. See [installation instructions](http://phantomjs.org/download.html).

Then you can add this line to your application's Gemfile:

    gem 'photograph'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install photograph

## Usage
Photograph can be used either directly through the Photograph::Artist
class or by its little Sinatra app.

### Basics
**Using `Artist.shoot!` without a block had been deprecated in 0.3 and
will raise an exception.**

Artist can be instanciated with an url to screenshot, calling ``#shoot!`` will take the screenshot and yields it. The screenshot is only accessible within the block as it is always deleted afterward.

    @artist = Photograph::Artist.new(:url => "http://github.com")
    @artist.shoot! do |image|
      image # => MiniMagick instance you can toy with

      # Sinatra? Serve screenshot to client with:
      send_file image.path, :type => :png

      # Jobs or Rake task ? Export screenshot with:
      FileUtils.cp(image.path, "/somewhere/image.png")
    end

### Cropping
To crop the screenshot, ``Artist.new`` accepts ``:x``, ``y``, ``w`` and ``h`` options:

    @artist = Photograph::Artist.new(:url => "http://github.com", :x => 100, :y => 100, :w => 800, :h => 600)

This will take a 800x600 screenshot, skipping 100 pixels top and left.

### Interacting with the page before shooting
If authentication is required (or any browser action), ``Artist#before`` allows to supply actions to be done before shooting. It yields a ``Capybara`` browser instance that respond to the usual methods, ``fill_in``, ``click_link`` [see for more details](https://github.com/jonleighton/poltergeist).

    @artist = Photograph::Artist.new(:url => "http://rubygems.org")
    @artist.before do |browser|
      browser.click_button("Sign in")
      browser.fill_in("Username", :with => "MyUsername")
      # ...
    end

    @artist.shoot! do |image|
      send_file image, :type => :png
    end

### RDOC

[Full Documentation](http://rdoc.info/gems/photograph/frames)

### As a web service

As having the web service builtin requires Sinatra and Thin, it had been extracted to [Photograph-Service](https://github.com/jhchabran/photograph-service).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

* Jean-Hadrien Chabran
* Danial Pearce

## License

Photograph is Copyright © 2013 JHCHABRAN. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
