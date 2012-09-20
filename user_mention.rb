module UserMention

  def mentions_by_user
    map_command = %q{
      function() {
        var mentions = this.entities.user_mentions,
            users = [];

        if (mentions.length > 0) {
          for(i in mentions) {
            users.push(mentions[i].id_str)
          }

          emit(this.user.id_str, { mentions: users });
        }
      }
    }

    reduce_command = %q{
      function(key, values) {
        var users = [];

        for(i in values) {
          users = users.concat(values[i].mentions);
        }

        return { mentions: users };
      }
    }

    options = {:out => {:inline => 1}, :raw => true, :limit => 50 }
    statuses.map_reduce(map_command, reduce_command, options)
  end

end
