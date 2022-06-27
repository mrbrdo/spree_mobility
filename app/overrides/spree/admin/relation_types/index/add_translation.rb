Deface::Override.new(
  virtual_path:  'spree/admin/relation_types/index',
  name:          'relation_types_index_translation',
  insert_top:    'td.actions',
  text:          <<-HTML
                  <%= link_to_with_icon 'translate', nil, spree.admin_translations_path('relation_types', relation_type.id), title: Spree.t(:'i18n.translations'), class: 'btn btn-sm btn-primary', no_text: true %>
                HTML
)
