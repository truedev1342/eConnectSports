class CardSocialsController < ApplicationController
before_action :authenticate_user!
private

def card_social_params
    params.require(:card_social).permit(:kind, :url)
end
end