Deface::Override.new(
  virtual_path:  'spree/admin/products/index',
  name:          'search_by_name_or_sku',
  replace: 'div[data-hook=admin_products_index_search] > div:first-child',
  text: <<-HTML

        <div class="col-12 col-lg-6">
          <div class="form-group">
            <%= f.label :search_by_name_or_sku, Spree.t(:name_or_sku) %>
            <%= f.text_field :search_by_name_or_sku, size: 15, class: "form-control js-quick-search-target js-filterable" %>
          </div>
        </div>

        <div class="col-12 col-lg-6">
          <div class="form-group">
            <%= f.label :search_by_name, Spree.t(:product_name) %>
            <%= f.text_field :search_by_name, size: 15, class: "form-control js-filterable" %>
          </div>
        </div>
        HTML
)
