class CardPhonesController < ApplicationController
before_action :authenticate_user!
private

def card_phone_params
    params.require(:card_phone).permit(:location, :nmbr)
end
end