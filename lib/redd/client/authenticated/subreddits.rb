module Redd
  module Client
    class Authenticated
      module Subreddits
        def get_subreddits(where = :subscriber, params = {})
          meth = :get
          path =
            if [:popular, :new].include?(where)
              "/subreddits/#{where}.json"
            elsif [:subscriber, :contributor, :moderator].include?(where)
              "/subreddits/mine/#{where}.json"
            end
          object_from_response(meth, path, params)
        end
      end
    end
  end
end
