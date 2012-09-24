module TweetMiner

  module Status

    class HourOfDayCounter
      def map_command
        'function() {
          var re = /(\d{2,2}):\d{2,2}:\d{2,2}/;
          var hour = re.exec(this.created_at)[1];

          emit(hour, 1);
        }'
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
