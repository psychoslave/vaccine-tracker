class Country < ApplicationRecord
  has_and_belongs_to_many :vaccines
  has_many :inoculations
end
