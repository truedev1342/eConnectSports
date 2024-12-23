class CardEmailsController < ApplicationController
before_action :authenticate_user!
private

def card_email_params
    params.require(:card_email).permit(:address)
end
end
