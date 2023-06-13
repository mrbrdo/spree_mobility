Deface::Override.new(
  virtual_path:  'spree/admin/countries/index',
  name:          'countries_translation',
  insert_top: 'td.actions > span:first',
  text:           <<-HTML
    <%= link_to_with_icon 'translate.svg',
      '',
      spree.admin_translations_path('countries', country.id),
      class: 'btn btn-sm btn-light',
      data: {
        action: 'translate'
      },
      title: Spree.t(:translations),
      no_text: true %>
                  HTML
)
