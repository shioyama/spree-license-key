class Spree::OrderObserver < ActiveRecord::Observer
  def after_transition(order, transition)
    if transition.to == "complete" && order.paid?
      order.after_finalize!
    end
  end
end
