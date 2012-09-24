module TweetMiner

  module Status

    class DayOfWeekCounter
      def map_command
        'function() {
          var re = /(^\w{3,3}).+(\d{2,2}):\d{2,2}:\d{2,2}/;
          var matches = re.exec(this.created_at);

          var wday = matches[1],
              hday = matches[2];

          emit(wday, { count: 1, hdayBreakdown: [{ hday: hday, count: 1 }] });
        }'
      end

      def reduce_command
        'function(key, values) {
           var total = 0,
               hdays = {},
               hdayBreakdown;

           for(i in values) {
             total += values[i].count

             hdayBreakdown = values[i].hdayBreakdown;

             for(j in hdayBreakdown) {
               hday  = hdayBreakdown[j].hday;
               count = hdayBreakdown[j].count;

               if( hdays[hday] == undefined ) {
                 hdays[hday] = count;
               } else {
                 hdays[hday] += count;
               }
             }
           }

           hdayBreakdown = [];
           for(k in hdays) {
             hdayBreakdown.push({ hday: k, count: hdays[k] })
           }

           return { count: total, hdayBreakdown: hdayBreakdown }
         }'
      end

    end



  end

end
