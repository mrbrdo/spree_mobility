require 'mobility'
require 'mobility/backends/active_record/table'

# Extend library classes
SpreeMobility.prepend_once(::Mobility::Backends::ActiveRecord::Table.singleton_class,
  SpreeMobility::CoreExt::Mobility::Backends::ActiveRecord::Table::MobilityActsAsParanoidDecorator)
