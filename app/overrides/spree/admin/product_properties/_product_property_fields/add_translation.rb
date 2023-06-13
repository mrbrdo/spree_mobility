Deface::Override.new(
  virtual_path:  'spree/admin/product_properties/_product_property_fields',
  name:          'product_property_translation',
  insert_top: 'td.actions > span:first',
  text:           <<-HTML
                    <% if f.object.persisted? %>
                      <%= link_to_with_icon 'translate.svg',
                        '',
                        spree.admin_translations_path('product_property', f.object.id),
                        class: 'btn btn-sm btn-light',
                        data: {
                          action: 'translate'
                        },
                        title: Spree.t(:translations),
                        no_text: true %>
                    <% end %>
                  HTML
)
