(RUBY_VERSION < '1.9.0') ? require('system_timer') : require('timeout')
require File.dirname(__FILE__) + '/../vendor/plain_imap'

module Fetcher
  class ImapTagged < Imap

    protected

    # Additional Options:
    # * <tt>:processed_tag</tt> - tag to assign for correctly processed mail, defaults to 'processed'
    # * <tt>:error_tag</tt> - tag to assign for incorrectly processed mail, defaults to 'bogus'
    # * <tt>:processed_folder</tt> - if set to the name of a mailbox, messages will be moved to that mailbox They are never deleted after processing. The mailbox will be created if it does not exist.
    # * <tt>:error_folder:</tt> - the name of a mailbox where messages that cannot be processed (i.e., your receiver throws an exception) will be moved.  No default. The mailbox will be created if it does not exist.
    def initialize(options={})
      @processed_tag = options.delete(:processed_tag) || 'processed'
      @error_tag = options.delete(:error_tag) || 'bogus'
      @error_folder = options.delete(:error_folder) || :no_folder
      super(options)
    end

    # Retrieve messages from server
    # Store the message for inspection if the receiver errors
    def handle_bogus_message(message, uid)
      # tag with @error_tag
      @connection.uid_store(uid, "+FLAGS", [@error_tag])

      unless @error_folder == :no_folder
        create_mailbox(@error_folder)
        @connection.append(@error_folder, message)
      end
    end

    def handle_successfully_processed_message(uid)
      #tag with processed_tag
      @connection.uid_store(uid, "+FLAGS", [@processed_tag])

      if @processed_folder
        create_mailbox(@processed_folder)
        @connection.uid_copy(uid, @processed_folder)
      end
    end

  end
end
