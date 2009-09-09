require "#{File.dirname(__FILE__)}/spec_setup"
require 'rack/cache/utils/options'

class MockOptions
  include Rack::Cache::Utils::Options

  option_accessor :foo

  def initialize
    @env = nil
    initialize_options
  end
end

describe 'Rack::Cache::Utils::Options' do
  before { @options = MockOptions.new }

  describe '#set' do
    it 'sets a Symbol option as rack-cache.symbol' do
      @options.set :bar, 'baz'
      @options.options['rack-cache.bar'].should.equal 'baz'
    end
    it 'sets a String option as string' do
      @options.set 'foo.bar', 'bling'
      @options.options['foo.bar'].should.equal 'bling'
    end
    it 'sets all key/value pairs when given a Hash' do
      @options.set :foo => 'bar', :bar => 'baz', 'foo.bar' => 'bling'
      @options.foo.should.equal 'bar'
      @options.options['rack-cache.bar'].should.equal 'baz'
      @options.options['foo.bar'].should.equal 'bling'
    end
  end

  it 'makes options declared with option_accessor available as attributes' do
    @options.set :foo, 'bar'
    @options.foo.should.equal 'bar'
  end

  it 'allows setting multiple options via assignment' do
    @options.options = { :foo => 'bar', :bar => 'baz', 'foo.bar' => 'bling' }
    @options.foo.should.equal 'bar'
    @options.options['foo.bar'].should.equal 'bling'
    @options.options['rack-cache.bar'].should.equal 'baz'
  end

  it "allows storing the value as a block" do
    block = Proc.new { "bar block" }
    @options.set(:foo, &block)
    @options.options['rack-cache.foo'].should.equal block
  end
end

describe 'Rack::Cache::Context using Rack::Cache::Utils::Options' do
  before { @context = Rack::Cache::Context.new(nil) }

  it 'allows the cache key generator to be configured' do
    @context.should.respond_to :cache_key
    @context.should.respond_to :cache_key=
  end

  it 'allows the meta store to be configured' do
    @context.should.respond_to :metastore
    @context.should.respond_to :metastore=
    @context.metastore.should.not.be nil
  end

  it 'allows the entity store to be configured' do
    @context.should.respond_to :entitystore
    @context.should.respond_to :entitystore=
    @context.entitystore.should.not.be nil
  end

  it 'allows log verbosity to be configured' do
    @context.should.respond_to :verbose
    @context.should.respond_to :verbose=
    @context.should.respond_to :verbose?
    @context.verbose.should.not.be.nil
  end
end
