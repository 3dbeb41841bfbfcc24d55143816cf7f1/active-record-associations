# rubocop:disable Style/ClassVars

# Our Base Class for Models that persist to the DB
class Model
  attr_reader :id

  def self.connection=(conn)
    @@db_conn = conn
  end

  def initialize(id)
    @id = id
  end
end
