module StatusCounter

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

  def status_count_by_user
    counter = UserCounter.new
    statuses.map_reduce(counter.map_command, counter.reduce_command, default_mr_options)
  end


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

  def status_count_by_hday(days_ago = 7)
    date     = Date.today - days_ago
    days_ago = Time.utc(date.year, date.month, date.day)
    query = { "created_at_dt" => { "$gte" => days_ago } }

    options = default_mr_options.merge(:query => query)

    counter = HourOfDayCounter.new
    statuses.map_reduce(counter.map_command, counter.reduce_command, options)
  end

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

  def status_count_by_wday
    counter = DayOfWeekCounter.new
    statuses.map_reduce(counter.map_command, counter.reduce_command, default_mr_options)
  end

  def default_mr_options
    {:out => {:inline => 1}, :raw => true }
  end

end
