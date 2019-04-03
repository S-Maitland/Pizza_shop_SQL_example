require ('pg')

class SqlRunner

  def SqlRunner.run(sql, values =[])
    #connect to database
    begin
      db = PG.connect({dbname: 'pizza_shop', host: 'localhost'})
      #prepare the statement
      db.prepare('query', sql)
      #run the exec prepared statement
      result = db.exec_prepared('query', values)
      #close the databse connection
    ensure
      db.close()
    end

    #return the result
    return result
  end

end
