class PaymentsController < ApplicationController
  include ActionView::Helpers::TextHelper
  before_action :authenticate_user!

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
      redirect_back(fallback_location: root_path, allow_other_host: false)
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
    if params[:promo_code].present?
      @promo = PromoCode.find_by(code: params[:promo_code])
      if @promo && !@promo.used
        total_purchased = current_user.cards_purchased.to_i + @promo.cards
        current_user.update(cards_purchased: total_purchased)
        @promo.user_id = current_user.id
        @promo.used = true
        @promo.save
        Payment.new(period: 12, user_id: current_user.id, card_id: params[:card_id]).save(validate: false)
        redirect_to root_path, notice: "You got #{pluralize(@promo.cards, 'card')}!" and return
      else
        redirect_back(fallback_location: root_path, allow_other_host: false, alert: 'Wrong promo code.') and return
      end
    end

    @payment = Payment.new(payment_params)
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
  def card_params
    params.require(:card).permit(:first_name, :last_name, :position, :highlights, :team_name, :card_name, :remove_image, :background, :background_tile, :remove_background, :card_phones_attributes, :card_emails_attributes, :card_websites_attributes, :card_socials_attributes, :stats_attributes, :membership_id, :user_id, :background1_color, :background2_color, :details_color, :name_color, :icon_color, :sport, :hometown, :season, :year, :league, :handed, :image, :crop_x, :crop_y, :crop_w, :crop_h, :user_token,:url_alias, :library_image, :background_cache)
  end

  def payment_params
    params.require(:payment).permit(:stripe_card_token, :stripe_customer_token, :email, :amount, :cards_purchased, :card_id, :period, :renew_payment, :user_id)
  end

  def promo_code_params
    params.require(:promo_code).permit(:cards, :code, :used)
  end
end
