class Project < ActiveRecord::Base
  DEFAULT_PROJECTS_COUNT = 4
  DEFAULT_CATAGORY_PROJECTS_COUNT = 4
  MORE_CATAGORY_PROJECTS_COUNT = 4
  DEFAULT_FILTER = 'Charity'
  DEFAULT_SORT = 'Popularity'
  PERMITTED_STATUS = [:Published, :Canceled, :Unpublished, :Reopen, :Expired, :Completed]

  TYPES = ['Charity', 'Investment']

  attr_writer :user_minimum_contribution
  
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :documents,-> { where(attachable_subtype: 'document') }, as: :attachable, dependent: :destroy
  has_many :images,-> { where(attachable_subtype: 'image') }, as: :attachable, class_name: "Document", dependent: :destroy
  has_many :transactions
  has_many :urls
  has_many :texts
  
  validates :title, :kind, :description, :end_date, :total_amount, presence: true
  validate :acceptable_total_amount, if: :total_amount?
  validates :total_amount, numericality: { greater_than: 100000 }, on: :create

  accepts_nested_attributes_for :documents, :images, reject_if: proc { |attributes| attributes['attachment'].blank? }
  
  scope :fetch_for_current_page, -> (projects_count, page_no) { limit_selection(projects_count, projects_count * (page_no - 1)).order(created_at: :desc) }
  scope :limit_selection, -> (limit, offset) { limit(limit).offset(offset) }

  scope :load_published, -> { where(status: 'Published') }
  scope :load_from_kind, -> (kind) { load_published.where(kind: (kind ||= DEFAULT_FILTER)) }

  def self.load_maximum_completed(kind=nil)
    load_from_kind(kind).eager_load(:transactions).to_a.sort_by { |p| p.percentage_completed }.reverse
  end

  def self.load_recently_created(limit=DEFAULT_PROJECTS_COUNT, offset=0, kind=nil)
    load_from_kind(kind).order(created_at: :desc).limit_selection(limit, offset)
  end

  def self.load_fully_completed(kind=nil)
    load_from_kind(kind).eager_load(:transactions).to_a.select { |p| p.percentage_completed == 100 }
  end

  def user_maximum_contribution
    @user_maximum_contribution ||= total_amount - amount_funded
  end

  def user_minimum_contribution
    if total_amount
      @user_minimum_contribution ||= total_amount / 10
      @user_minimum_contribution = @user_maximum_contribution if @user_minimum_contribution.to_i > user_maximum_contribution
    end
    @user_minimum_contribution
  end

  def percentage_completed
    @percentage_compteted ||= ( amount_funded / total_amount.to_f) * 100
  end

  def amount_funded
    transactions.to_a.sum(&:amount)
  end

  def get_contributers_count
    transactions.to_a.uniq{ |t| t.user_id }.count
  end

  def update_status(new_status)
    if status_valid?(new_status.intern)
      last_status = status;
      send_cancellation_mail(last_status) if update(status: new_status)
      true
    end
  end
  
  def as_json(options={})
    { title: title, type: kind, percentage_completed: percentage_completed, amount_funded: amount_funded }
  end

  def published?
    status.eql?('Published')
  end

private

  def send_cancellation_mail(last_status)
    if last_status.eql?('Published') && status.eql?('Canceled')
      send_mail_to_contributors
    end
  end

  def status_valid?(status)
    status && PERMITTED_STATUS.include?(status)
  end

  def send_mail_to_contributors
    transactions.eager_load(:user, :project).each do |transaction|
      if transaction.refund
        UserMailer.send_project_cancelation_mail(transaction).deliver_now
      end
    end
  end

  def acceptable_total_amount
    errors.add(:total_amount, 'must be in multiple of 100') unless (total_amount % 100).zero?
  end

end

