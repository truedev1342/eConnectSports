class CardWebsitesController < ApplicationController
before_action :authenticate_user!

private

def card_website_params
    params.require(:card_website).permit(:url, :name)
end
end