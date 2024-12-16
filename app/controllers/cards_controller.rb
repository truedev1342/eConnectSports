class CardsController < ApplicationController
  before_filter :authenticate_user!,
    :only => [:destroy, :new, :edit]

  @@disallowed_aliases = %w(contacts plans shares admin resque users memberships teams public_pages cards appointments easily-accessible customer-interaction-points schedule-appointments personal-digidex create-teams email-signatures qr-code tutorials single-shop industry-connect privacy-policy qrcode-store email 404 422 500)

  def show
    @card = Card.find(params[:id])

    # unless @card.url_alias.blank?
    #   redirect_to root_url + @card.url_alias, status: 301, notice: flash[:notice] and return
    # end

    respond_to do |format|
      format.html
      format.json { render json: @card }
    end
  end

  def new
    if (current_user.cards_purchased.to_i - current_user.cards.count) < 0
      redirect_to new_payment_path
    else
      @user = current_user
      @card = @user.cards.build(params[:card])

      respond_to do |format|
        format.html
        format.json { render json: @card }
      end
    end
  end

  def create
    if current_user
      @user = current_user
      @card = @user.cards.new(params[:card])
    else
      token = session[:user_token] || cookies[:user_token]
      @card = Card.find_by_user_token(token) || Card.new(params[:card])
      if @card.id?
        render 'show' and return
      end
    end
    @card.advanced_data = params[:card][:library_image] if params[:card][:library_image]

    check_availability_of_url_alias
    
    respond_to do |format|
      if @card.save
        notice = 'Card was successfully created.'
        notice += "<br>Your card will be deleted in 24 hours unless you create your profile!" unless @card.user_id
        if params[:card][:image].present?
          format.html { render :crop }
        else
          record_activity("Created <b>#{@card.card_name}</b> card") #This will call application controller record_activity
          format.html { redirect_to @card, notice: notice}
          format.json { render json: @card, status: :created, location: @card }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @card = Card.find(params[:id])
    unless @card.paid?
      if @card.payments.count > 0
        notice = 'Your card was expired, you need to renew this card if you want to continue use.'
      end
      redirect_to "#{new_payment_path}?card_id=#{@card.id}", notice: notice and return
    end
  end

  def update
    @card = Card.find(params[:id])
    @card.advanced_data = params[:card][:library_image] if params[:card][:library_image]

    check_availability_of_url_alias

    respond_to do |format|
      if @card.update_attributes(params[:card])
        if params[:card][:image].present?
          format.html { render :crop }
        else
          record_activity("Updated <b>"+@card.card_name+"</b> card") #This will call application controller record_activity
          format.html { redirect_to @card, notice: 'Card was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @card = Card.find(params[:id])

    @card.destroy

    respond_to do |format|
      record_activity("Deleted <b>"+@card.card_name+"</b> card") #This will call application controller record_activity
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  # Custom actions

  def calendar
    @card = @card = Card.find(params[:id])
  end

  def vcard
    @card = @card = Card.find(params[:id])

    card = Vpim::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        name.given = @card.first_name
        name.family = @card.last_name
      end

      maker.add_addr do |addr|
        addr.preferred = true
        addr.location = 'work'
        addr.street = @card.address1.to_s+', '+@card.address2.to_s
        addr.region = @card.state.to_s
        addr.country = 'United States'
        addr.postalcode = @card.zip_code.to_s
      end

      #maker.add_photo do |photo|
      #  photo.link = 'http://example.com/image.png'
      #end

      #maker.add_photo do |photo|
      #  photo.image = "File.open('drdeath.jpg').read # a fake string, real data is too large :-)"
      #  photo.type = 'jpeg'
      #end

      maker.org = @card.business_name.to_s

      maker.title = @card.title.to_s

      @card.card_phones.each do |phone|
        if phone.location == 1
          @location = 'home'
        elsif phone.location == 2
          @location = 'cell'
        elsif phone.location == 3
          @location = 'work'
        end
        if phone.location == 4
          maker.add_tel('+1'+phone.nmbr) do |tel|
            tel.location = 'work'
            tel.capability = 'fax'
          end
        else
          maker.add_tel('+1'+phone.nmbr) { |t| t.location = @location}
        end
      end

      @card.card_emails.each do |email|
        unless email.blank?
            maker.add_email(email.address.to_s)
        end
      end
    end

    send_data(card.to_s, :type => 'text/vcard; charset=utf-8', :filename => "contact.vcf", :disposition => 'attachment')
  end

  def send_vcard
    @card = Card.find(params[:card_id])
    VcardMailer.send_vcard(params[:vcard_email], @card).deliver
    flash[:notice] = "Email was sent successfully."
    redirect_to :back
  end

  def new_demo_card
    if session[:user_token].present?
      token = session[:user_token]
      @card = Card.find_by_user_token(token) || Card.new(user_token: token)
    elsif cookies[:user_token].present?
      token = cookies[:user_token]
      @card = Card.find_by_user_token(token) || Card.new(user_token: token)
    else
      token = Devise.friendly_token
      @card = Card.new(user_token: token)
    end
    session[:user_token] = token
    cookies[:user_token] = {value: token, expires: Time.now + 24.hours}

    @user = User.new

    if @card.id?
      render 'show'
    else
      render 'new'
    end
  end

  def check_url_alias
    if @@disallowed_aliases.include? params[:url_alias]
      render json: {result: 'busy'} and return
    end
    status = 'free'
    card = Card.find_by_url_alias(params[:url_alias])
    if card
      status = 'busy'
    else
      user = User.find_by_username(params[:url_alias])
      status = user ? 'busy' : 'free'
    end
    render json: {result: status}
  end

  private
    def check_availability_of_url_alias
      if params[:card] && params[:card][:url_alias]
        if @@disallowed_aliases.include? params[:card][:url_alias]
          params[:card].delete(:url_alias)
        end
      end
    end
end
