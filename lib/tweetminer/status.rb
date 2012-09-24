require "tweetminer/status/user_counter"
require "tweetminer/status/hour_of_day_counter"
require "tweetminer/status/day_of_week_counter"
require "tweetminer/status/mention_by_user"

module TweetMiner

  module Status

    def status_count_by_user
      counter = UserCounter.new
      statuses.map_reduce(counter.map_command, counter.reduce_command, default_mr_options)
    end

    def status_count_by_hday(days_ago = 7)
      date     = Date.today - days_ago
      days_ago = Time.utc(date.year, date.month, date.day)
      query = { "created_at_dt" => { "$gte" => days_ago } }

      options = default_mr_options.merge(:query => query)

      counter = HourOfDayCounter.new
      statuses.map_reduce(counter.map_command, counter.reduce_command, options)
    end

    def status_count_by_wday
      counter = DayOfWeekCounter.new
      statuses.map_reduce(counter.map_command, counter.reduce_command, default_mr_options)
    end

    def mentions_by_user
      options = default_mr_options.merge(:limit => 50)
      mr      = MentionByUser.new

      statuses.map_reduce(mr.map_command, mr.reduce_command, options)
    end

    def default_mr_options
      {:out => {:inline => 1}, :raw => true }
    end

  end

end
