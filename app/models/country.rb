class Country < ApplicationRecord
  has_many :vaccines
  has_many :inoculations
end
