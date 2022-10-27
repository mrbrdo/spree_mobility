Deface::Override.new(
  virtual_path:  'spree/admin/shared/sortable_tree/_taxonomy',
  name:          'taxonomy_tree_translations',
  insert_bottom: '.sortable-tree-item-row > div:last',
  text:           <<-HTML
                    <%= link_to_with_icon 'translate', nil, spree.admin_translations_path('taxons', taxon.id), title: Spree.t(:'i18n.translations'), class: 'btn btn-sm btn-primary', no_text: true %>
                  HTML
)
