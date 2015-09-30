class Order < ActiveRecord::Base
  has_one :lineitem, dependent: :restrict_with_error
  attr_accessor :name
  validates :status, presence: true

  scope :test, where(id: 1) do |arg2|
    def nested_test
      p arg2
    end
  end

  before_validation :b4_v
  before_create :b4_c
  before_save :b4_s
  before_update :b4_u
  before_destroy :b4_d

  around_save :around_s
  around_create :around_c
  around_destroy :around_d

  after_find :after_f
  after_initialize :after_i
  after_touch :after_t

  after_validation :after_v
  after_create :after_c
  after_save :after_s
  after_update :after_u
  after_destroy :after_d

  after_commit :after_comm
  after_rollback :after_roll

private
  
  def b4_v
    p "before validation of Order"
  end
  def b4_c
    p "before create of Order"
  end
  def b4_s
    p "before save  of Order"
  end
  def b4_u
    p "before update of Order"
  end
  def b4_d
    p "before destroy of Order"
  end
  def around_c
    p "before yield in around_create of Order"
    yield
    p "after yield in around_create of Order"
  end
  def around_s
    p "before yield in around save of order"
    yield
    p "after yield in around save of Order"
  end
  def around_d
    p "before yield in around destroy of Order"
    yield
    p "after yield in around destroy of Order"
  end
  def after_s
    p "after save of Order"
  end
  def after_c
    p "after create of Order"
  end
  def after_d
    p "after destroy of Order"
    raise "dsfs"
  end
  def after_v
    p "after validation of Order"
  end
  def after_f
    p "after find of Order"
  end
  def after_i
    p "after initialize of Order"
  end
  def after_t
    p "after touch of Order"
  end
  def after_u
    p "after update of Order"
  end
  def after_comm
    p "after commit of Order"
  end
  def after_rollback
    p "after rollback of Order"
  end
  def after_roll
    p "after rollback of LineItem"
  end

end


