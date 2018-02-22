class PayController < ApplicationController
  def index
    transaction_api = SquareConnect::TransactionsApi.new
    location_id = Rails.application.secrets.square_location_id

    # multiply amount by 100 due to Square handling all
    # currencies in lowest denomination
    body = {
      idempotency_key: SecureRandom.uuid,
      amount_money: {
        amount: params[:amount].to_f * 100,
        currency: SquareConnect::Currency::USD
      },
      card_nonce: params[:card-nonce]
    }

    begin
      transaction_api.charge(location_id, body)
    rescue SquareConnect::ApiError => e
      puts "Failed to call charge: #{e.response_body}"
    end
  end
end
