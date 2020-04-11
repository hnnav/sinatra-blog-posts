class Post < ActiveRecord::Base
    belongs_to :user

    def self.valid_params?(params)
        return !params[:title].empty? && !params[:content].empty?
    end
end