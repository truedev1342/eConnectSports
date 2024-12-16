class SavedCardsController < ApplicationController
  before_filter :authenticate_user!
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

end
