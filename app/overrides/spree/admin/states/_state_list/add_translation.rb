Deface::Override.new(
  virtual_path:  'spree/admin/states/_state_list',
  name:          'states_translations',
  insert_top: 'td.actions > span:first',
  text:           <<-HTML
    <%= link_to_with_icon 'translate.svg',
      '',
      spree.admin_state_translations_path(state.country, 'state', state.id),
      class: 'btn btn-sm btn-light',
      data: {
        action: 'translate'
      },
      title: Spree.t(:translations),
      no_text: true %>
                  HTML
)
