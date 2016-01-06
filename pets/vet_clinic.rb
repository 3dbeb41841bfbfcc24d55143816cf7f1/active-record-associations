# rubocop:disable Metrics/MethodLength
# rubocop:disable Metrics/CyclomaticComplexity

require 'pg'
require_relative 'owner'
require_relative 'pet'

# VetClinic manages a DB of Owners and Pets
class VetClinic
  def initialize
    # Connect to the Database
    ActiveRecord::Base.establish_connection(
      adapter:  'postgresql', # or 'mysql2' or 'sqlite3'
      host:     'localhost',
      database: 'vet_clinic3'
      # username: 'your_username',
      # password: 'your_password'
    )
  end

  def run
    while process_command(ask_user); end
  end

  private

  def ask_user
    puts
    puts 'What would you like to do?'
    puts '(IO) See an index of all owners'
    puts '(CO) Create a new owner'
    puts '(RO) See details on a specific owner'
    puts '(UO) Update an owner'
    puts '(DO) Delete an owner'
    puts '(IP) See an index of all pets'
    puts '(CP) Create a new pet'
    puts '(RP) See details on a specific pet'
    puts '(UP) Update a pet'
    puts '(DP) Delete a pet'
    puts '(Q)  Quit'
    gets.chomp.upcase
  end

  def process_command(command)
    keep_going = true
    case command
    when 'IO' then do_index_owners
    when 'CO' then do_create_owner
    when 'RO' then do_read_owner
    when 'UO' then do_update_owner
    when 'DO' then do_delete_owner
    when 'IP' then do_index_pets
    when 'CP' then do_create_pet
    when 'RP' then do_read_pet
    when 'UP' then do_update_pet
    when 'DP' then do_delete_pet
    when 'Q'  then keep_going = false
    else
      puts 'That is not a valid command'
    end
    keep_going
  end

  def get_response(prompt)
    puts prompt
    gets.chomp
  end

  def do_index_owners
    puts 'Owners'
    owners = Owner.all
    puts owners
  end

  def do_create_owner
    first_name = get_response('Enter the first name of the owner: ')
    last_name  = get_response('Enter the last name of the owner: ')
    Owner.new('first_name' => first_name, 'last_name' => last_name).save
    puts "#{first_name} #{last_name} has been added to the database."
  end

  def do_read_owner
    id = get_response('Enter the id of the owner:').to_i
    owner = Owner.find(id)
    puts owner ? owner : 'Owner not found'
  end

  def do_update_owner
    id = get_response('Enter the id of the owner:').to_i
    owner = Owner.find(id)
    if owner
      owner.first_name = get_response('Enter the first name of the owner:')
      owner.last_name  = get_response('Enter the last name of the owner:')
      owner.save
    else
      puts 'Owner not found'
    end
  end

  def do_delete_owner
    id = get_response('Enter the id of the owner:').to_i
    owner = Owner.find(id)
    if owner
      owner.destroy
    else
      puts 'Owner not found'
    end
  end

  def do_index_pets
    puts 'Pets'
    pets = Pet.all
    puts pets
  end

  def do_create_pet
    name      = get_response('Enter the name of the pet:')
    type      = get_response('Enter the type of the pet:')
    age       = get_response('Enter the age of the pet:')
    owner_id  = get_response('Enter the owner id of the pet:')
    Pet.new('name'     => name,
            'type'     => type,
            'age'      => age,
            'owner_id' => owner_id).save
    puts "#{name} has been added to the database."
  end

  def do_read_pet
    id = get_response('Enter the id of the pet:').to_i
    pet = Pet.find(id)
    puts pet ? pet : 'Pet not found'
  end

  def do_update_pet
    id = get_response('Enter the id of the pet:').to_i
    pet = Pet.find(id)
    if pet
      pet.name      = get_response('Enter the name of the pet:')
      pet.type      = get_response('Enter the type of the pet:')
      pet.age       = get_response('Enter the age of the pet:')
      pet.owner_id  = get_response('Enter the owner id of the pet:')
      pet.save
    else
      puts 'Pet not found'
    end
  end

  # new stuff:
  def do_delete_pet
    id = get_response('Enter the id of the pet:').to_i
    pet = Pet.find(id)
    if pet
      pet.destroy
    else
      puts 'Pet not found'
    end
  end
end

vet_clinic = VetClinic.new
vet_clinic.run
