class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :project


  before_validation :b4_v_c
  before_create :b4_c_c
  before_save :b4_s_c
  before_update :b4_u
  before_destroy :b4_d

  around_save :around_s_c
  around_create :around_c_c
  around_destroy :around_d

  after_find :after_f_c
  after_initialize :after_i_c
  after_touch :after_t

  after_validation :after_v_c
  after_create :after_c_c
  after_save :after_s_c
  after_update :after_u
  after_destroy :after_d

  after_commit :after_comm_c
  after_rollback :after_roll

private
  
  def b4_v_c
    p "before validation of Comment"
  end
  def b4_c_c
    p "before create of Comment"
  end
  def b4_s_c
    p "before save  of Comment"
  end
  def b4_u
    p "before update of Comment"
  end
  def b4_d
    p "before destroy of Comment"
  end
  def around_c_c
    p "before yield in around_create of Comment"
    yield
    p "after yield in around_create of Comment"
  end
  def around_s_c
    p "before yield in around save of Comment"
    yield
    p "after yield in around save of Comment"
  end
  def around_d
    p "before yield in around destroy of Comment"
    yield
    p "after yield in around destroy of Comment"
  end
  def after_s_c
    p "after save of Comment"
  end
  def after_c_c
    p "after create of Comment"
  end
  def after_d
    p "after destroy of Comment"
  end
  def after_v_c
    p "after validation of Comment"
  end
  def after_f_c
    p "after find of Comment"
  end
  def after_i_c
    p "after initialize of Comment"
  end
  def after_t
    p "after touch of Comment"
  end
  def after_u
    p "after update of Comment"
  end
  def after_comm_c
    p "after commit of Comment"
  end
  def after_roll
    p "after rollback of Comment"
  end

  def self.remove(id)
    begin
      destroy(id)
    rescue ActiveRecord::RecordNotFound
    end
  end

end
