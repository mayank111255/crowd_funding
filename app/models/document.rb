class Document < ActiveRecord::Base
  SUBTYPES = [:current_address, :permanent_address, :PAN]
  
  belongs_to :attachable, polymorphic: true

  has_attached_file :attachment,
    url: ":rails_root/public/system/:attachment/:id/:basename_:style.:extension",
    styles: { 
      medium: "100x100>",
      slider: '350x350!',
      large: '600x600!'
    }

  validates_attachment :attachment,
    presence: true,
    content_type: {
      content_type: ["attachment/pdf", "attachment.doc", "image/jpeg"]
    }

end