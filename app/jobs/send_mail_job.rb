class SendMailJob
  include Sidekiq::Worker
  sidekiq_options retry: false, queue: :critical
  def perform(user_id, token_type)
    user = User.find_by(id: user_id)
    p "======#{user.id}"
    UserMailer.send("send_#{token_type}_mail".intern, user).deliver
  end

end