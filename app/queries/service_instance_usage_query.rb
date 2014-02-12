class ServiceInstanceUsageQuery
  attr_reader :instance

  def initialize(instance)
    @instance = instance
  end

  def execute
    escaped_database = ActiveRecord::Base.sanitize(instance.database)
    query = <<-SQL
      SELECT SUM(ROUND(((data_length + index_length) / 1024 / 1024), 2))
      FROM information_schema.TABLES
      WHERE table_schema = #{escaped_database}
    SQL

    result_set = ActiveRecord::Base.connection.execute(query).first
    result = result_set.first
    result.to_f
  end

end
