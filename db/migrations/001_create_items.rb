Sequel.migration do
  up do
    run 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"' # use uuid postgresql extension

    create_enum(:item_status, %w(pending published rejected draft deleted))

    create_table :items do
      column :id, :uuid, default: Sequel.function(:uuid_generate_v4), primary_key: true, null: false
      column :user_id, :uuid, null: false, index: true
      String :content, text: true
      item_status :status, default: "pending", null: false
      column :private, :boolean, null: false, default: false
      Time :created_at, null: false
      Time :updated_at
    end
  end

  down do
    drop_table :items
    drop_enum :item_status
  end
end
