class SavedCardsController < ApplicationController
  before_action :authenticate_user!
  def create
    card = Card.find(params['card_id'])
    current_user.favorite_cards << card
    current_user.save
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  def destroy
    saved_card = SavedCard.where(user_id: current_user.id, card_id: params['card_id']).first
    saved_card.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
  private
  def card_params
    params.require(:card).permit(first_name, :last_name, :position, :highlights, :team_name, :card_name, :remove_image, :background, :background_tile, :remove_background, :card_phones_attributes, :card_emails_attributes, :card_websites_attributes, :card_socials_attributes, :stats_attributes, :membership_id, :user_id, :background1_color, :background2_color, :details_color, :name_color, :icon_color, :sport, :hometown, :season, :year, :league, :handed, :image, :crop_x, :crop_y, :crop_w, :crop_h, :user_token,:url_alias, :library_image, :background_cache)
  end
end
