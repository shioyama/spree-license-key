class Spree::PaymentObserver < ActiveRecord::Observer
  def after_transition(payment, transition)
    if transition.to == 'completed'
      payment.order.after_finalize!
    end
  end
end
