class Lineitem < ActiveRecord::Base
	belongs_to :order

  # validates :quantity, numericality: {
  # 	greater_than_or_equal_to: 30,
  # 	message: 'gaandu'
  # }

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
    p "before validation of LineItem"
  end
  def b4_c
    p "before create of LineItem"
  end
  def b4_s
    p "before save  of LineItem"
  end
  def b4_u
    p "before update of LineItem"
  end
  def b4_d
    p "before destroy of LineItem"
  end
  def around_c
    p "before yield in around_create of LineItem"
    yield
    p "after yield in around_create of LineItem"
  end
  # if yield is not used, the query is never fired actually..so yield has to b there.
  def around_s
    p "before yield in around save of LineItem"
    yield
    p "after yield in around save of LineItem"
  end
  def around_d
    p "before yield in around destroy of LineItem"
    yield
    p "after yield in around destroy of LineItem"
  end
  def after_s
    p "after save of LineItem"
  end
  def after_c
    p "after create of LineItem"
  end
  def after_d
    p "after destroy of LineItem"
  end
  def after_v
    p "after validation of LineItem"
  end
  def after_f
    p "after find of LineItem"
  end
  def after_i
    p "after initialize of LineItem"
  end
  def after_t
    p "after touch of LineItem"
  end
  def after_u
    p "after update of LineItem"
  end
  def after_comm
    p "after commit of LineItem"
  end
  def after_roll
  	p "after rollback of LineItem"
  end

end
