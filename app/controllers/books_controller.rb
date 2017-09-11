class BooksController < ApplicationController


    def index
        
    end

    def search
        @books = []
        @books = Book.search(params[:q], params[:search_type]) if !params[:q].blank?
        render json: {books: @books }
    end
end
