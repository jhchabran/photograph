# Photograph

Photograph solves the issue of generating previews or thumbnails of
web-based documents. Think of generating a preview of a Google
Spreadsheet. As a such document is dom based, it may be difficult to get a preview
that truly reflects the original content. 

Photograph solves that problem by firing a chrome instance thanks to
capybara-webkit and sinatra to provides an easy way to interface it to
your needs. 

Obviously, it supports cropping to avoid reworking the image afterward.

Please remind that having a chrome instance, even if it is being reused
by all requests is still taking some time, aroung 600ms after the first 
request on my development machine. *Consider using photograph only if
you expect the same exact rendering of your 'web documents'*.

## Installation

Add this line to your application's Gemfile:

    gem 'photograph'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install photograph

## Usage

Photograph can be used either directly through the Photograph::Artist
class or by its little sinatra app. 

    @artist = Photograph::Artist.new("http://github.com")
    @artist.shoot!

    @artist.image
    # => MiniMagick instance you can toy with

Or 

    $ bundle exec photograph -h 127.0.0.1 -p 4567

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits


Photograph is maintained and funded by Tactilize.

Contributors : 

* Jean-Hadrien Chabran

The names and logos for Tactilize are trademarks of Tactilize.

## License

Photograph is Copyright © 2012 Tactilize. It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
