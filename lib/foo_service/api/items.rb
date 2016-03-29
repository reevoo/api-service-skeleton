require "api_service_skeleton/models/client"
require "api_service_skeleton/models/client_module"

module ApiServiceSkeleton
  class API < Grape::API
    class Items < Grape::API
      resource :items, desc: "Items management" do
        desc "Returns all items", entity: Item::SimpleEntity, is_array: true
        get do
          query = Item
          query = query.where(id: current_user.client_id) unless has_permission?(:items, :list)
          present query.order(Sequel.function(:lower, :name)).all, with: ApiServiceSkeleton::Item::SimpleEntity
        end

        desc "Query items", entity: Item::Entity, is_array: true
        params do
          optional :search,  type: String, valid_search_query: true
          optional :trkrefs, type: String, valid_search_query: true
          optional :client_uuids, type: Array[String], documentation: { param_type: "form", allowMultiple: true }
        end
        post :query do
          check_permission(:items, :list)
          query = Item
          if params[:search]
            query = query.search(params[:search])
          elsif params[:trkrefs]
            query = query.search_by_trkrefs(params[:trkrefs])
          elsif params[:client_uuids]
            query = query.search_by_client_uuids(params[:client_uuids])
          end
          status 200
          range = content_range(:items, query.count)
          present query.order(Sequel.function(:lower, :name)).in_range(range).all
        end

        desc "Returns a single client", entity: Item::Entity
        params do
          requires :id, type: String, valid_uuid: true
        end
        route_param :id do
          get do
            check_permission :items, :show
            client = Item.find_by_id(params[:id])
            fail NotFound unless client
            present client
          end
        end

        desc "Creates an item", entity: Item::Entity
        params do
          requires :name, type: String, desc: "Item name"
          optional :trkrefs, type: Array[String], desc: "Associated TRKREFs",
                             documentation: { param_type: "form", allowMultiple: true }
          optional :contract_expiry, type: Date
          optional :accessible_modules, type: Array[String], values: ItemModule::ACCESSIBLE_MODULES,
                                        documentation: { param_type: "form", allowMultiple: true }
          optional :accessible_dashboards, type: Array[String],
                                           documentation: { param_type: "form", allowMultiple: true }
        end
        post do
          check_permission :items, :create
          client = Item.create(declared(params, include_missing: false))
          present client
        end

        desc "Updates an item", entity: Item::Entity
        params do
          requires :id, type: String, desc: "Item id", valid_uuid: true
          optional :name, type: String, desc: "Item name"
          optional :state, type: String, values: ApiServiceSkeleton::Item::STATES
          optional :trkrefs, type: Array[String], desc: "Associated TRKREFs",
                             documentation: { param_type: "form", allowMultiple: true }
          optional :contract_expiry, type: Date
          optional :accessible_modules, type: Array[String], values: ItemModule::ACCESSIBLE_MODULES,
                                        documentation: { param_type: "form", allowMultiple: true }
          optional :accessible_dashboards, type: Array[String],
                                           documentation: { param_type: "form", allowMultiple: true }
        end
        route_param :id do
          put do
            check_permission :items, :update
            client = Item.find_by_id(params[:id])
            fail NotFound unless client
            client.update(declared(params, include_missing: false).except(:id))
            present client
          end
        end

        desc "Deletes an item", entity: Item::Entity
        params do
          requires :id, type: String, desc: "Item id", valid_uuid: true
        end
        route_param :id do
          delete do
            check_permission :items, :delete
            client = Item.find_by_id(params[:id]) or fail NotFound
            present client.soft_delete
          end
        end
      end
    end
  end
end
