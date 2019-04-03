require_relative('../db/sql_runner.rb')
require_relative('customer.rb')

class PizzaOrder

  attr_accessor :topping, :quantity, :customer_id
  attr_reader :id

  def initialize(options)
    @id = options["id"].to_i() if options["id"]
    @topping = options['topping']
    @quantity = options['quantity'].to_i()
    @customer_id = options['customer_id'].to_i()
  end

  def save()
    sql = "INSERT INTO pizza_orders (topping, quantity, customer_id) VALUES ($1, $2, $3) RETURNING id"
    values = [@topping, @quantity, @customer_id]
    results = SqlRunner.run(sql, values)
    @id = results[0]["id"].to_i()
  end

  def self.all()
    sql = "SELECT * FROM pizza_orders"
    results = SqlRunner.run(sql)
    return results.map {|order| PizzaOrder.new(order)}
  end

  def self.delete_all()
    sql = "DELETE FROM pizza_orders"
    SqlRunner.run(sql)
  end

  def delete()
    sql = "DELETE FROM pizza_orders WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def update()
    sql = "UPDATE pizza_orders SET (topping, quantity, customer_id) = ($1, $2, $3) WHERE id = $4"
    values = [@topping, @quantity, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM pizza_orders WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)[0]
    return PizzaOrder.new(result)
  end

  def customer()
    sql = 'SELECT * FROM customers WHERE id = $1'
    values = [@customer_id]
    result = SqlRunner.run(sql, values)[0]
    return Customer.new(result)
  end


end
