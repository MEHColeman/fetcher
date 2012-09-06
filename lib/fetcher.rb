module Fetcher
  # Use factory-style initialization or insantiate directly from a subclass
  #
  # Options:
  # * <tt>:type</tt> - Name of class as a symbol to instantiate
  #
  # Other options are the same as Fetcher::Base.new
  # 
  # Example:
  # 
  # Fetcher.create(:type => :pop) is equivalent to
  # Fetcher::Pop.new()
  def self.create(options={})
    klass = options.delete(:type)
    raise ArgumentError, 'Must supply a type' unless klass
    module_eval "#{klass.to_s.capitalize}.new(options)"
  end
end

require_relative 'fetcher/base'
require_relative 'fetcher/pop'
require_relative 'fetcher/imap'
require_relative 'fetcher/imap_tagged'
