# Spree 4.3.x or older
Deface::Override.new(
  virtual_path:  'spree/admin/shared/_product_tabs',
  name:          'product_tabs_translation_spree_4_3',
  insert_bottom: "[data-hook='admin_product_tabs']",
  text:          <<-HTML
                  <li>
                    <%= link_to_with_icon 'translate', Spree.t(:'i18n.translations'), spree.admin_translations_url('products', @product.slug), class: "\#\{'active' if current == 'Translations'\} nav-link" %>
                  </li>
                HTML
)

# Spree 4.4+
Deface::Override.new(
  virtual_path:  'spree/admin/shared/_product_tabs',
  name:          'product_tabs_translation',
  insert_after: "erb:contains('can?(:admin, Spree::Digital)')",
  text:          <<-HTML

  <%= content_tag :li, class: 'nav-item' do %>
    <%= link_to_with_icon 'translate.svg',
      Spree.t(:'i18n.translations'),
      spree.admin_translations_url('products', @product.slug),
      class: "nav-link \#\{'active' if current == 'Translations'\}" %>

  <% end if can?(:admin, Spree::Product) %>
                HTML
)
