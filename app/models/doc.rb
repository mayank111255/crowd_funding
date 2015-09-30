class Doc < ActiveRecord::Base
  has_many :sections
  has_many :paragraphs, through: :sections, source: :para, source_type: :Paragraph
end