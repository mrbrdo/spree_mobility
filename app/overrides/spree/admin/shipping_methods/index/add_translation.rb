Deface::Override.new(
  virtual_path:  'spree/admin/shipping_methods/index',
  name:          'shipping_methods_translation',
  insert_top: 'td.actions > span:first',
  text:           <<-HTML
    <%= link_to_with_icon 'translate.svg',
      '',
      spree.admin_translations_path('shipping_methods', shipping_method.id),
      class: 'btn btn-sm btn-light',
      data: {
        action: 'translate'
      },
      title: Spree.t(:translations),
      no_text: true %>
                  HTML
)
