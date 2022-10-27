// This is only needed for Spree 4.3.x and older
Spree.ready(function () {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  root.taxon_tree_menu = function(obj, context) {
    var admin_base_url, edit_url, id, translation_base_path, translation_url;
    id = obj.attr("id");
    admin_base_url = Spree.url(Spree.routes.admin_taxonomy_taxons_path);
    edit_url = admin_base_url.clone();
    edit_url.setPath(edit_url.path() + '/' + id + "/edit");
    translation_url = Spree.url(admin_base_url.path().replace(/\/taxonomies\/\d.+$/, '') + '/taxons/' + id + '/translations');
    return {
      create: {
        label: "<span class='icon icon-plus'></span> " + Spree.translations.add,
        action: function(obj) {
          return context.create(obj);
        }
      },
      rename: {
        label: "<span class='icon icon-pencil'></span> " + Spree.translations.rename,
        action: function(obj) {
          return context.rename(obj);
        }
      },
      remove: {
        label: "<span class='icon icon-trash'></span> " + Spree.translations.remove,
        action: function(obj) {
          return context.remove(obj);
        }
      },
      edit: {
        separator_before: true,
        label: "<span class='icon icon-cog'></span> " + Spree.translations.edit,
        action: function(obj) {
          return window.location = edit_url.toString();
        }
      },
      translate: {
        separator_before: true,
        label: "<span class='icon icon-flag'></span> " + Spree.translations.translations,
        action: function(obj) {
          return window.location = translation_url.toString();
        }
      }
    };
  };

});
