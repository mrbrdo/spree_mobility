module Spree
  class Admin::TranslationsController < Admin::BaseController
    before_action :load_parent

    if defined?(SpreeI18n::ControllerLocaleHelper)
      helper 'spree_i18n/locale'
    end

    helper_method :collection_url

    def index
      render resource_name
    end

    def update
      params[:translation].each_pair do |attribute, data|
        data.each_pair do |locale, value|
          I18n.with_locale(locale) do
            resource.public_send("#{attribute}=", value)
            if resource.kind_of?(::Spree::Taxonomy)
              # There is a bug with Taxonomy#set_root_taxon_name
              # after_update hook that would cause an infinite loop
              class << resource
                def set_root_taxon_name
                end
              end
            end
            resource.save!
          end
        end
      end

      redirect_to url_for(:controller => "translations", :action => "index")
    end

    private

    def load_parent
      set_resource_ivar(resource)
    end

    def resource_name
      params[:resource].singularize
    end

    def set_resource_ivar(resource)
      instance_variable_set("@#{resource_name}", resource)
    end

    def klass
      @klass ||= "Spree::#{params[:resource].classify}".constantize
    end

    def resource
      @resource ||= klass.find(params[:resource_id])
    end

    def collection_url
      ActionController::Routing::Routes.recognize_path("admin_#{resource_name}_url", @resource)
      send "admin_#{resource_name}_url", @resource
    rescue
      send "edit_admin_#{resource_name}_url", @resource
    end
  end
end
