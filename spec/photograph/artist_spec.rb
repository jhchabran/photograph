require 'spec_helper'

module Photograph
  describe Artist do
    let(:url) { 'http://rubygems.org' }
    subject   { Artist.new :url => url }

    describe '.new' do
      it { expect(subject).to be_kind_of(Artist) }

      it('raises an error when not given a url') do
        expect{ Artist.new }.to raise_error(Artist::MissingUrlError)
      end

      it('should leave http version of url untouched as it is already valid') do
        expect(subject.options[:url]).to eq(url)
      end

      it('should leave https version of url untouched as it is already valid') do
        expect(Artist.new(:url => 'https://rubygems.org').options[:url]).to eq('https://rubygems.org')
      end

      it('should prepend http:// to the url if protocol is not present') do
        expect(Artist.new(:url => 'github.com').options[:url]).to eq('http://github.com')
      end
    end

    describe '#options' do
      it('should have default value for x') { expect(subject.options[:x]).to eq(0) }
      it('should have default value for y') { expect(subject.options[:y]).to eq(0) }
      it('should have default value for w') { expect(subject.options[:w]).to eq(1280) }
      it('should have default value for h') { expect(subject.options[:h]).to eq(1024) }
    end

    describe '#shoot!' do
      context 'when browser has been provided' do
        let(:browser) { Capybara::Session.new(:poltergeist) }
        subject       { Artist.new(:url => url, :browser => browser) }

        it 're-uses the browser provided to Artist#new' do
          browser.should_receive(:visit)
          subject.shoot! {}
        end
      end

      it 'should locally set capybara default time' do
        subject.shoot!{ expect(Capybara.default_wait_time).to eq(15) }
        expect(Capybara.default_wait_time).to eq(2)
      end

      it('should accept a block when shooting') do
        subject.shoot!{|image| image.should respond_to(:path) }
      end

      it('should raise an exception if no block was given when shooting') do
        expect{ subject.shoot! }.to raise_error(Artist::DeprecationError)
      end

      describe 'Cropping' do
        subject { Artist.new :url => url, :x => 200, :y => 100, :h => 400, :w => 400 }
        before { subject.browser.driver.stub(:render) }

        xit 'should take a screenshot large enough to crop later' do
          subject.shoot!
        end
      end
    end

    describe "#before" do
      subject { Artist.new :url => url }
      before do
        subject.browser.driver.stub(:visit)
        subject.browser.driver.stub(:click_link)
        subject.browser.driver.stub(:render)
        subject.stub(:adjust_image)
      end

      it('should call the before hook before shooting') do
        subject.before do |browser|
          browser.click_link "Use the API"
        end

        allow(subject.browser).to receive(:click_link)
        subject.shoot! {}
      end
    end
  end
end
