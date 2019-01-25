class Vote < ApplicationRecord
  belongs_to :entry
  belongs_to :member
end
