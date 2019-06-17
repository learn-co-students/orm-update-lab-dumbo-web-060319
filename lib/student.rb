require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :name, :grade, :id
  def initialize(name, grade, id = nil)
    @id = id 
    @name = name 
    @grade = grade 
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students 
      (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save 
    if self.id 
      self.update 
    else 
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end

  end

  def self.create(n,g)
    newStudent = Student.new(n,g)
    newStudent.save 
  end
  def self.new_from_db(arrayGiven)
    newStudent = Student.new(arrayGiven[1], arrayGiven[2], arrayGiven[0])
    return newStudent
  end
  def self.find_by_name(nameGiven)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1 
    SQL

    another = DB[:conn].execute(sql, nameGiven)
    newStudent = Student.new(another[0][1], another[0][2], another[0][0])
    newStudent
  end 

  def update 
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
end
