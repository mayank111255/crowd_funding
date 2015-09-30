class User < ActiveRecord::Base
  DEFAULT_DOCUMENTS_COUNT = 3

  has_one :profile, dependent: :destroy
  has_many :documents, as: :attachable, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :transactions
  # has_many :texts
  # has_many :circles
  # has_many :friends, through: :circles
  has_and_belongs_to_many :friends, join_table: :friends, class_name: 'User', foreign_key: :user_id, association_foreign_key: :friend_id, after_add: :create_friend

  accepts_nested_attributes_for :profile, :documents

  has_attached_file :image,
    url: ":rails_root/public/:class/:attachment/:id/:basename_:style.:extension",
    default_url: ":rails_root/public/:class/:attachment/default.jpg",
    styles: {
      thumb: ['100x100#', :jpg],
      medium: [ '150x150!', :jpg],
      large: ['600>', :jpg]
    },
    default_style: :medium
  
  validates_attachment :image, content_type: { content_type: ["image/jpeg"] }  
  has_secure_password

  validates :name, :email, presence: true
  validates :password_confirmation, presence: true, unless: [:token_type, :account_updation]
  validates :password, presence: true, on: [:update], unless: [:token_type, :account_updation]
  validates :password, length: { minimum: 8 }, allow_blank: true
  validates_with EmailValidator, if: :email?, on: [:create], allow_blank: true
  validates :email, uniqueness: true, on: [:create], allow_blank: true
  validates :reset_password_token, :account_activation_token, uniqueness: true, allow_nil: true, if: :token_type

  before_create :set_defaults, unless: :role?
  after_save :send_mail, if: :token_type
  before_save :nullify_password_tokens, if: :is_password_changed

  attr_accessor :token_type, :account_updation, :is_password_changed
  delegate :phone_no, :permanent_address, :current_address, :permanent_account_number, to: :profile, allow_nil: true

  scope :load_users, -> (users_count, page_no) { where(role: :user).limit(users_count).offset(users_count * (page_no - 1)).order(created_at: :desc) }
  scope :count_all_users, -> { where(role: :user).count }
  ##################################
  
  # before_validation :b4_v
  # before_create :b4_c
  # before_save :b4_s
  # before_update :b4_u
  # before_destroy :b4_d

  # around_save :around_s
  # around_create :around_c
  # around_destroy :around_d

  # after_find :after_f
  # after_initialize :after_i
  # after_touch :after_t

  # after_validation :after_v
  # after_create :after_c, prepend: true
  # after_save :after_s
  # after_update :after_u
  # after_destroy :after_d

  # after_commit :after_comm
  # after_rollback :after_roll

  # #################################
  
  # def create_friend(record)
  #   record.friends << self if record.friends.exclude?(self)
  # end

  def nullify_password_tokens
    self.reset_password_token, self.reset_password_token_generated_at = nil, nil
  end

  def update_password(user_params, is_password_changed = false)
    self.is_password_changed = is_password_changed
    update(user_params)
  end

  def generate_reset_password_token
    self.token_type, self.reset_password_token, self.reset_password_token_generated_at = 'reset_password', *generate_token
    save
  end

  def generate_account_activation_token
    self.token_type, self.account_activation_token, self.account_activation_token_generated_at = 'account_activation', *generate_token
    save
  end

  def activate_account
    update(is_activated: true, account_activation_token: nil, account_activation_token_generated_at: nil)
  end

  def update_account(update_params)
    self.account_updation = true
    update(update_params)
  end

  def build_associated_objects
    build_profile unless profile
    unless documents.present?
      DEFAULT_DOCUMENTS_COUNT.times do |index|
        documents.build(attachable_subtype: Document::SUBTYPES[index])
      end
    end
  end

  def profile_complete?
    return false unless profile && profile.complete?
    documents.length == DEFAULT_DOCUMENTS_COUNT
  end

  def get_attachment(type)
    attachment = documents.where(attachable_subtype: type)
    attachment[0].attachment_file_name if attachment.present?
  end

  def contributions
    transactions.eager_load(:project).order(created_at: :desc)
  end
  
private

  def send_mail
    UserMailer.send("send_#{token_type}_mail".intern, self).deliver_now
  end

  def set_defaults
    self.role = 'user'
  end

  def generate_token
    [BCrypt::Password.create(SecureRandom.hex(5)), Time.current]
  end

  # def b4_v
  #   p "before validation of Text"
  # end
  # def b4_c
  #   p "before create of Text"
  # end
  # def b4_s
  #   p "before save  of Text"
  # end
  # def b4_u
  #   p "before update of Text"
  # end
  # def b4_d
  #   p "before destroy of Text"
  # end
  # def around_c
  #   p "before yield in around_create of Text"
  #   yield
  #   p "after yield in around_create of Text"
  # end
  # def around_s
  #   p "before yield in around save of Text"
  #   yield
  #   p "after yield in around save of Text"
  # end
  # def around_d
  #   p "before yield in around destroy of Text"
  #   yield
  #   p "after yield in around destroy of Text"
  # end
  # def after_s
  #   p "after save of Text"
  # end
  # def after_c
  #   p "after create of Text"
  # end
  # def after_d
  #   p "after destroy of Text"
  # end
  # def after_v
  #   p "after validation of Text"
  # end
  # def after_f
  #   p "after find of Text"
  # end
  # def after_i
  #   p "after initialize of Text"
  # end
  # def after_t
  #   p "after touch of Text"
  # end
  # def after_u
  #   p "after update of Text"
  # end
  # def after_comm
  #   p "after commit of Text"
  # end
  # def after_rollback
  #   p "after rollback of Text"
  # end
  # def after_roll
  #   p "after rollback of Text"
  # end

end
