class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :project


# private
  
#   def self.remove(id)
#     begin
#       destroy(id)
#     rescue ActiveRecord::RecordNotFound
#     end
#   end

end
