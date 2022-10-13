Deface::Override.new(
  virtual_path:  'spree/admin/states/_state_list',
  name:          'states_translations',
  insert_bottom: 'td.actions > span:first',
  text:           <<-HTML
                    <%= link_to_with_icon 'translate', nil, spree.admin_state_translations_path(state.country, state.id), title: Spree.t(:'i18n.translations'), class: 'btn btn-sm btn-primary', no_text: true %>
                  HTML
)
