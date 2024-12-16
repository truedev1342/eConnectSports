class PaymentsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_filter :authenticate_user!

  def index #use existing payment for card
    if params[:card_id]
      card = Card.find(params[:card_id])
      card.use_payment
      if card.paid?
        notice = 'You successfully activated your card.'
      else
        notice = 'Sorry, you have to purchase more cards.'
      end
      redirect_to card, notice: notice
    else
      redirect_to :back
    end
  end

  def new
    @payment = Payment.new
    if params[:card_id].present?
      @payment.card_id = params[:card_id].to_i
      # @renew_payment = !!Payment.select(:id).where(card_id: @payment.card_id).first
      @renew_payment  = false
    end
    if !current_user.nil? && !current_user.cards_purchased.nil?
      @buy_more = current_user.cards_purchased > 0 ? true : false
    else
      @buy_more = false
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
    end
  end

  def create
    @payment = Payment.new(params[:payment])
    @payment.user = current_user
    @payment.email = current_user.email
    @previous_purchased = current_user.cards_purchased
    #set unlimated period
    @payment.period = 120
    @new_purchased = @payment.cards_purchased
    if !current_user.nil? && !current_user.cards_purchased.nil?
      @buy_more = current_user.cards_purchased > 0 ? true : false
    else
      @buy_more = false
    end

    if params[:promo_code].present?
      @promo = PromoCode.find_by_code(params[:promo_code])
      if @promo && !@promo.used
        total_purchased = current_user.cards_purchased.to_i + @promo.cards
        current_user.update_attributes(:cards_purchased => total_purchased)
        @promo.user_id = current_user.id
        @promo.used = true
        @promo.save
        Payment.new(period: 12, user_id: current_user.id, card_id: params[:card_id]).save(validate: false)
        redirect_to root_path, notice: "You got #{pluralize(@promo.cards, 'card')}!" and return
      else
        redirect_to :back, alert: 'Wrong promo code.' and return
      end
    end
    if @payment.purchase(@buy_more)
      if  @payment.status.to_i == 3
        if true #@payment.renew_payment == "false" || !@payment.renew_payment
          @total_purchased = @previous_purchased.to_i+@new_purchased
          current_user.update_column('cards_purchased', @total_purchased)
          sale_amount=@payment.amount/100.round(2)
          sale_number=@payment.transaction_number
          sales_share="https://shareasale.com/sale.cfm?amount=#{sale_amount}&tracking=#{sale_number}&transtype=sale&merchantID=47937"
          notice = "Success! You can now have #{@total_purchased} cards! #{ActionController::Base.helpers.image_tag sales_share, style: "display:none;height=1;width=1"}".html_safe
        else
          notice = "Your card was renewed for #{pluralize(@payment.period, 'week')}."
          redirect_to root_path, notice: notice and return
        end
        sale_amount=@payment.amount/100.round(2)
        sale_number=@payment.transaction_number
        sales_share="https://shareasale.com/sale.cfm?amount=#{sale_amount}&tracking=#{sale_number}&transtype=sale&merchantID=47937"
        redirect_to thank_you_path(amount:sale_amount,trans_id:sale_number), :notice => notice
      else
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  def show
    @payment = Payment.find(params[:id])

  end

  def thank_you
    @amount=params[:amount]
    @trans_number=params[:trans_id]
  end

  private
  def check_for_payment
    if current_user.payments.last
      d_id=current_user.payments.last.transaction_number
      p_id=params[:trans_id]
      redirect_to new_payment_path unless d_id==p_id
    end
  end
end
