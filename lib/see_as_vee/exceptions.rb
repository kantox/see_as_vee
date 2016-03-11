module SeeAsVee
  module Exceptions
    class SeeAsVeeError < ::StandardError
    end

    class FileFormatError < SeeAsVeeError
      def initialize file
        file = file.path if file.is_a?(IO)
        super "File [#{file}] does not seem to be valid spreadsheet"
      end
    end

    class BadInputError < SeeAsVeeError
      def initialize object
        super "Do not know what to do with an instance of #{object.class}: #{object.inspect}"
      end
    end
  end
end
