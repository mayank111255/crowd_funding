class Section < ActiveRecord::Base
  belongs_to :doc
  belongs_to :para, polymorphic: true
end