class StatsController < ApplicationController
    private
    def stat_params
		params.require(:stat).permit(:abbr, :name, :value, :kind)
	end
end
