class Paragraph < ActiveRecord::Base
  has_many :sections, as: :para
end