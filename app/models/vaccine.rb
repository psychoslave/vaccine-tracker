class Vaccine < ApplicationRecord
  has_many :inoculations
  has_many :countries
end
