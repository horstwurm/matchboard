class Mcategory < ActiveRecord::Base
    has_many :mobjects
    has_many :companies
    has_many :articles
    has_many :questions
    has_many :dataloaders
    has_many :games
end
