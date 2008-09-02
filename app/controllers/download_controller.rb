class DownloadController < ApplicationController
    def show
        redirect_to FetchMboxFile.new(params[:id]).address
    end
end