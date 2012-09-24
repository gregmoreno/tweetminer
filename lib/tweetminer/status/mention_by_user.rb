module TweetMiner

  module Status

    class MentionByUser
      def map_command
        cmd = %q{
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
      end

      def reduce_command
        cmd = %q{
          function(key, values) {
            var users = [];

            for(i in values) {
              users = users.concat(values[i].mentions);
            }

            return { mentions: users };
          }
        }
      end

    end

  end

end
