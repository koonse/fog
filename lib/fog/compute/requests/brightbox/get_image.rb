module Fog
  module Compute
    class Brightbox
      class Real

        def get_image(identifier, options = {})
          return nil if identifier.nil? || identifier == ""
          request(
            :expects  => [200],
            :method   => 'GET',
            :path     => "/1.0/images/#{identifier}",
            :headers  => {"Content-Type" => "application/json"},
            :body     => MultiJson.encode(options)
          )
        end

      end
    end
  end
end