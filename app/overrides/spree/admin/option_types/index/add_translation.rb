Deface::Override.new(
  virtual_path:  'spree/admin/option_types/index',
  name:          'option_types_index_translation',
  insert_top:    'td.actions > span:first',
  text:          <<-HTML
    <%= link_to_with_icon 'translate.svg',
      '',
      spree.translations_admin_option_type_path(option_type.id),
      class: 'btn btn-sm btn-light',
      data: {
        action: 'translate'
      },
      title: Spree.t(:translations),
      no_text: true %>
                HTML
)
