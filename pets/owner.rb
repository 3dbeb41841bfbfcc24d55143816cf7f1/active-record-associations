require 'active_record'

# An Owner of Pets
class Owner < ActiveRecord::Base
  has_many :pets, dependent: :delete_all
  validates_presence_of :first_name, :last_name

  def to_s
    "#{id}: #{first_name} #{last_name}"
  end
end
