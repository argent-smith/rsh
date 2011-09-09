# Various utility I use in my gemming practice
# Author:: Pavel Argentov <argentoff@gmail.com>
module AgUtils # :nodoc:

  # Utility for Rubinius
  module Rbx
    class << self

      # Returns true if we're on Rubinius
      def found?
        begin
          RUBY_ENGINE == "rbx"
        rescue NameError
          false
        end
      end

    end

  end

end
