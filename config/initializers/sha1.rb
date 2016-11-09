# config/initializers/sha1.rb
require 'digest/sha1'

module Devise
  module Encryptable
    module Encryptors
      class Sha1 < Base
        def self.digest(password, stretches, salt, pepper)
          str = [salt, password].flatten.compact.join
					Digest::SHA1.hexdigest(str)
        end
      end
    end
  end
end
