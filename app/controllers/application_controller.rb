class ApplicationController < ActionController::Base
  # protect_from_forgery with: :exception
  protect_from_forgery unless: -> { request.format.json? }

  helper_method :amount_raised

  def amount_raised
  	total = Item.where(item_purchase_state: 1).sum(:item_price_in_cents)
	if total.present?
		return total
	else
		return nil
	end
  end
end
