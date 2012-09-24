module TweetMiner

  module Status

    class UserCounter
      def map_command
        <<-EOS
          function() {
            emit(this.user.id_str, 1);
          }
        EOS
      end

      def reduce_command
        <<-EOS
          function(key, values) {
            var count = 0;

            for(i in values) {
              count += values[i]
            }

            return count;
          }
        EOS
      end

    end

  end
end
