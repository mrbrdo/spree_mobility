require "mobility/backends/active_record/table"

module ::Mobility::Backends::ActiveRecord
  module MobilityActsAsParanoidDecorator
    private
    def using_acts_as_paranoid?
      translation_class = model_class.const_get(subclass_name)
      return false unless translation_class
      translation_class.column_names.include?('deleted_at')
    end

    # If joining a table with a deleted_at column (acts_as_paranoid), then
    # filter the join with deleted_at IS NULL
    def join_translations(relation, locale, join_type)
      if using_acts_as_paranoid?
        # check if joins changed
        old_joins = relation.joins_values
        relation = super
        new_joins = relation.joins_values - old_joins
        return relation if new_joins.empty?
        fail "join_translations new_joins.size > 1" unless new_joins.size == 1
        # append deleted_at IS NULL to joins ON clause using Arel
        new_join = new_joins.first
        joined_table = model_class.const_get(subclass_name).arel_table.alias(table_alias(locale))
        relation.joins_values -= [new_join]
        new_join.right = new_join.right.and(joined_table[:deleted_at].eq(nil))
        relation.joins(new_join)
      else
        super
      end
    end
  end
end

SpreeMobility.prepend_once(::Mobility::Backends::ActiveRecord::Table.singleton_class, ::Mobility::Backends::ActiveRecord::MobilityActsAsParanoidDecorator)