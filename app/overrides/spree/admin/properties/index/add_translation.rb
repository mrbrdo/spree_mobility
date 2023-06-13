Deface::Override.new(
  virtual_path:  'spree/admin/properties/index',
  name:          'properties_translation',
  insert_top: 'td.actions > span:first',
  text:           <<-HTML
    <%= link_to_with_icon 'translate.svg',
      '',
      spree.admin_translations_path('properties', property.id),
      class: 'btn btn-sm btn-light',
      data: {
        action: 'translate'
      },
      title: Spree.t(:translations),
      no_text: true %>
                  HTML
)
