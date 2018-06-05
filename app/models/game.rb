class Game < ApplicationRecord
    belongs_to :user
    belongs_to :mobject
    belongs_to :mcategory
    has_many :results
end
