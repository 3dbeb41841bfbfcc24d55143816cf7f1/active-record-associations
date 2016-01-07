require_relative 'model'
require_relative 'pet'

# An Owner of Pets
class Owner < Model
  attr_accessor :first_name, :last_name

  def initialize(args)
    super(args['id'])
    @first_name = args['first_name']
    @last_name  = args['last_name']
  end

  def self.all
    result_set = @@db_conn.exec('SELECT * FROM owners ORDER BY id')
    result_set.map do |owner|
      Owner.new(owner)
    end
  end

  def self.find(id)
    result_set = @@db_conn.exec("SELECT * FROM owners WHERE id = #{id}").first
    result_set ? Owner.new(result_set) : nil
  end

  def save
    if id
      @@db_conn.exec('UPDATE owners SET ' \
                     "first_name = '#{first_name}', " \
                     "last_name  = '#{last_name}' " \
                     "WHERE id = #{id}")
    else
      @@db_conn.exec('INSERT INTO owners (first_name, last_name) VALUES ' \
                   "('#{first_name}', '#{last_name}')")
    end
  end

  def destroy
    owner_pets = Pet.find_by_owner(id)
    owner_pets.each(&:destroy)
    @@db_conn.exec("DELETE FROM owners WHERE id = #{id}")
  end

  def to_s
    "#{id}: #{first_name} #{last_name}"
  end
end
