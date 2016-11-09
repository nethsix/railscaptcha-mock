class CreateSites < ActiveRecord::Migration[5.0]
  def change
    if (table_exists? :site)
      rename_table :site, :sites
      #add changes here
    else
      create_table :sites do |t|
        t.string  :domain, limit: 2000
        t.string  :site_key, null: false, limit: 100
        t.string  :private_key, null: false, limit: 100
        t.string  :global_site, null: false, limit: 100
        t.string  :widget_type, null: false, limit: 50
        t.string  :app_type, null: false, limit: 50, default: 'WEBSITE'
        t.integer :user_id, null: false
        t.boolean :duplicate_numbers
        t.boolean :user_geolocation, default: true
        t.boolean :white_label, default: false
        t.string  :custom_audio_dir, limit: 255
        t.string  :custom_audio_lang, limit: 255
        t.string  :custom_css_dir, limit: 255
        t.string  :custom_message
        t.string  :custom_sender_id, limit: 50
        t.boolean :inmediate_voice_fallback, default: false, null: false
        t.boolean :use_unicode_support, default: false, null: false
        t.string  :ad_template, limit: 20
        t.string  :custom_support_email, limit: 255, default: nil
        t.integer :custom_retry_timer
        t.integer :custom_session_timer, default: nil
        t.string  :store_ids, default: nil
        t.string  :app_name, limit: 100
        t.string  :app_schemes, default: nil
        t.string  :app_data, default: nil
        t.string  :unavailable_platform_fallback_url, default: nil
        t.boolean :has_auto_retry, default: false
        t.datetime :deleted_at
        t.references :artist
        t.timestamps
        # relations if we want to build them in later.
        #relations:
        #User: { class: sfGuardUser, local: user_id, foreign: id, foreignAlias: Sites, onDelete: CASCADE }
        #UserPhones: { class: UserPhone, refClass: SiteUserPhone, local: site_id, foreign: user_phone_id, foreignAlias: Sites }
        #Countries: { class: Country, refClass: EnabledCountry, local: app_id, foreign: country_iso }
      end
    end
  end
end
