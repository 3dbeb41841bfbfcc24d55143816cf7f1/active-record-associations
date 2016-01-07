# rubocop:disable Metrics/MethodLength

require_relative 'model'

# A Pet
class Pet < Model
  attr_accessor :name, :age, :type, :owner_id

  def initialize(args)
    super(args['id'])
    @name = args['name']
    @age  = args['age']
    @type = args['type']
    @owner_id = args['owner_id']
  end

  def self.all
    result_set = @@db_conn.exec('SELECT * FROM pets')
    result_set.map do |pet|
      Pet.new(pet)
    end
  end

  def self.find(id)
    result_set = @@db_conn.exec("SELECT * FROM pets WHERE id = #{id}").first
    result_set ? Pet.new(result_set) : nil
  end

  def self.find_by_owner(owner_id)
    result_set = @@db_conn.exec('SELECT * FROM pets ' \
                                "WHERE owner_id = #{owner_id}")
    result_set.map do |pet|
      Pet.new(pet)
    end
  end

  # new stuff
  def save
    if id
      @@db_conn.exec('UPDATE pets SET ' \
                     "name = '#{name}', " \
                     "type  = '#{type}', " \
                     "age  = '#{age}', " \
                     "owner_id  = '#{owner_id}' " \
                     "WHERE id = #{id}")
    else
      @@db_conn.exec('INSERT INTO pets (name, type, age, owner_id) VALUES ' \
                   "('#{name}', '#{type}', '#{age}', '#{owner_id}')")
    end
  end

  def destroy
    @@db_conn.exec("DELETE FROM pets WHERE id = #{id}")
  end

  def to_s
    "#{id}: #{type} #{name} #{age} #{owner_id}"
  end
end
