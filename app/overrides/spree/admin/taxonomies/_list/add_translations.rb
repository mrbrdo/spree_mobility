Deface::Override.new(
  virtual_path:  'spree/admin/taxonomies/_list',
  name:          'taxonomies_translation',
  insert_bottom: 'td.actions > span:first',
  text:           <<-HTML
                    <%= link_to_with_icon 'translate', nil, spree.admin_translations_path('taxonomies', taxonomy.id), title: Spree.t(:'i18n.translations'), class: 'btn btn-sm btn-primary', no_text: true %>
                  HTML
)

Deface::Override.new(
  virtual_path:  'spree/admin/shared/sortable_tree/_taxonomy',
  name:          'taxons_translation',
  insert_bottom: 'div.space-buttons',
  text:           <<-HTML
                    <%= link_to_with_icon 'translate', nil, spree.admin_translations_path('taxons', taxon.id), title: Spree.t(:'i18n.translations'), class: 'btn btn-sm btn-primary', no_text: true %>
                  HTML
)
