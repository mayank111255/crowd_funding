class EmailValidator < ActiveModel::Validator
  def validate(record)
    unless record.email.match(EMAIL_REGEXP)
      record.errors[:email] << "invalid"
    end
  end
end

