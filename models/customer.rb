require_relative('../db/sql_runner.rb')
require_relative('pizza_order.rb')

class Customer
  attr_accessor :first_name, :last_name
  attr_reader :id

  def initialize(options)
    @id = options['id'].to_i() if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
  end

  def save()
    sql = 'INSERT INTO customers (
    first_name,
    last_name)
    VALUES ($1, $2)
    RETURNING id
    '
    values = [@first_name, @last_name]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i()
  end

  def self.all()
    sql = 'SELECT * FROM customers'
    results = SqlRunner.run(sql)
    return results.map{|customer| Customer.new(customer)}
  end

  def self.delete_all()
    sql = 'DELETE FROM customers'
    SqlRunner.run(sql)
  end

  def pizza_orders()
    sql = 'SELECT * FROM pizza_orders WHERE customer_id = $1'
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map {|order| PizzaOrder.new(order)}
  end

end
