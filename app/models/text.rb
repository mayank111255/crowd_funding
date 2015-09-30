class Text < Comment
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
  after_create :after_c, prepend: true
  after_save :after_s
  after_create :after_c
  after_update :after_u
  after_destroy :after_d

  after_commit :after_comm
  after_rollback :after_roll

private
  
  def b4_v
    p "before validation of Text"
  end
  def b4_c
    p "before create of Text"
  end
  def b4_s
    p "before save  of Text"
  end
  def b4_u
    p "before update of Text"
  end
  def b4_d
    p "before destroy of Text"
  end
  def around_c
    p "before yield in around_create of Text"
    yield
    p "after yield in around_create of Text"
  end
  def around_s
    p "before yield in around save of Text"
    yield
    p "after yield in around save of Text"
  end
  def around_d
    p "before yield in around destroy of Text"
    yield
    p "after yield in around destroy of Text"
  end
  def after_s
    p "after save of Text"
    raise "fdsf"
  end
  def after_c
    p "after create of Text"
  end
  def after_d
    p "after destroy of Text"
  end
  def after_v
    p "after validation of Text"
  end
  def after_f
    p "after find of Text"
  end
  def after_i
    p "after initialize of Text"
  end
  def after_t
    p "after touch of Text"
  end
  def after_u
    p "after update of Text"
  end
  def after_comm
    p "after commit of Text"
  end
  def after_rollback
    p "after rollback of Text"
  end
  def after_roll
    p "after rollback of Text"
  end

end