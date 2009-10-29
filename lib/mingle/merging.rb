module Mingle
  module Merging
    
    def merge(victim, options = {})
      raise IncompatibleTypes.new unless victim.class === self
      
      merge_attributes(victim, options)
      merge_all_associations(victim) if valid?
      
      returning(valid?) { |valid| save and victim.destroy if valid }
    end
    
    def merge_all_associations(victim)
      self.class.reflect_on_all_associations.each do |assoc|
        merge_association(victim, assoc.name)
      end
    end
    
    def merge_association(victim, assoc_name)
      assoc = self.class.reflect_on_association(assoc_name)
      __send__("merge_#{assoc.macro}_association", victim, assoc)
    end
    
  private
    
    def merge_attributes(victim, options)
      keepers    = Merging.extract_list(options, :keep)
      overwrites = Merging.extract_list(options, :overwrite)
      
      attributes.each do |key, value|
        next if keepers.include?(key.to_sym)
        next unless value.nil? or overwrites.include?(key.to_sym)
        write_attribute(key, victim[key])
      end
    end
    
    def merge_has_many_association(victim, assoc)
      key = connection.quote_column_name(assoc.primary_key_name)
      victim.__send__(assoc.name).update_all("#{key} = #{id}", "#{key} = #{victim.id}")
    end
    
    def merge_has_and_belongs_to_many_association(victim, assoc)
      key = connection.quote_column_name(assoc.primary_key_name)
      connection.execute <<-SQL
        UPDATE #{connection.quote_table_name(assoc.options[:join_table])}
        SET #{key} = #{id}
        WHERE #{key} = #{victim.id}
      SQL
    end
    
    def self.extract_list(hash, key)
      list = hash[key] || []
      [list].flatten
    end
    
  end
end

