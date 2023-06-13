Deface::Override.new(
  virtual_path:  'spree/admin/shared/sortable_tree/_taxonomy',
  name:          'taxonomy_tree_translations',
  insert_top: '.sortable-tree-item-row > div:last',
  text:           <<-HTML
    <%= link_to_with_icon 'translate.svg',
      '',
      spree.translations_admin_taxonomy_taxon_path(taxon.taxonomy, taxon.id),
      class: 'btn btn-sm btn-light',
      data: {
        action: 'translate'
      },
      title: Spree.t(:translations),
      no_text: true %>
                  HTML
)
