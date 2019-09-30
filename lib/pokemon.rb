class Pokemon
    attr_accessor :id, :name, :type, :db

    def initialize(poke_hash)
        @id = poke_hash[:id]
        @name = poke_hash[:name]
        @type = poke_hash[:type]
        @db = poke_hash[:db]
    end

    def self.save(name, type, db)
        sql = <<-SQL
            INSERT INTO pokemon (name, type)
            VALUES (?, ?)
        SQL

        db.execute(sql, name, type)

        @id = db.execute("SELECT last_insert_rowid() FROM pokemon;")
    end

    def self.find(id, db)
        sql = <<-SQL
            SELECT *
            FROM pokemon
            WHERE id = ?
        SQL

        pokemon = db.execute(sql, id).map do |poke_data|
            poke_hash = {
                id: poke_data[0],
                name: poke_data[1],
                type: poke_data[2], 
                db: db
            }
            self.new(poke_hash)
        end.first
        pokemon
    end
end
