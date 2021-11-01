class Vaccine < ApplicationRecord
  has_many :inoculations
  has_and_belongs_to_many :countries
end
