require 'json'
require 'phonelib'

class AppController < ApplicationController
  before_action :authenticate_user!, except: [:test]
  layout 'dashboard'

  def index
    @user = current_user
    @user_sites = Site.where(:user_id => @user.id)
    @page_is = "APP"
    render :index
  end

  def test
    render layout: false
  end

  def transactions
    @page_is = "APP"
    @app_id = params[:id]
    before = params[:before]
    after = params[:after]
    number = params[:number]
    from = params[:from]
    to = params[:to]

    @user = current_user
    @check_owner = Site.find(@app_id)

    @pagination_off = false
    if after.present?
      after_day = TransactionLog.find(after)
      @transactions = TransactionLog.where("created_at <= :date", date: after_day["created_at"])
      .order('created_at DESC').where(:site_id => @app_id).limit(50)
    elsif number.present?
      if from.present?  && to.present?
        @transactions = TransactionLog.where("created_at >= :date", date: from)
        .where("created_at <= :date", date: to).order('created_at DESC')
        .where(:site_id => @app_id).where(:to_number => number).limit(50)
        @pagination_off = true
      elsif from .present?
        @transactions = TransactionLog.where("created_at >= :date", date: from)
        .order('created_at DESC').where(:site_id => @app_id)
        .where(:to_number => number).limit(50)
        @pagination_off = true
      elsif to.present?
        @transactions = TransactionLog.where("created_at <= :date", date: to)
        .order('created_at DESC').where(:site_id => @app_id)
        .where(:to_number => number).limit(50)
        @pagination_off = true
      elsif number.present?
        @transactions = TransactionLog.where(:site_id => @app_id).order('created_at DESC')
        .where(:to_number => number).where(:to_number => number).limit(50)
        @pagination_off = true
      else
        @transactions = TransactionLog.where(:site_id => @app_id).order('created_at DESC')
        .where(:to_number => number).limit(50)
        @first_run = true
      end
    elsif from.present?  && to.present?
      @transactions = TransactionLog.where("created_at >= :date", date: from)
      .where("created_at <= :date", date: to).order('created_at DESC').where(:site_id => @app_id).limit(50)
      @pagination_off = true
    elsif from.present?
      @transactions = TransactionLog.where("created_at >= :date", date: from)
      .order('created_at DESC').where(:site_id => @app_id).limit(50)
      @pagination_off = true
    elsif to.present?
      @transactions = TransactionLog.where("created_at <= :date", date: to)
      .order('created_at DESC').where(:site_id => @app_id).limit(50)
      @pagination_off = true
    else
      @transactions = TransactionLog.where(:site_id => @app_id).order('created_at DESC').limit(50)
      @first_run = true
    end

    @transaction_count = TransactionLog.where(:site_id => @app_id).count
    @country_list = country_map("give_full_map")

    p @check_owner.user_id
    if @check_owner.user_id == @user.id
      render :transactions
    else
      redirect_to :apps
    end

  end

  def create
    if request.xhr?
      render :layout => false
    end
  end

  def sub
    @appType = params[:create_app][:appType]
    @isInvalid = params[:create_app][:isInvalid]

    if request.xhr?
      if @appType == 'WEBSITE'
        @domain = params[:create_app][:domain]

        #if valid create app
        if !@isInvalid && (!@domain.to_s.strip.empty?)
          @Site = Site.new
          @user = current_user
          @Site.domain = @domain
          @Site.site_key = create_token(20, 4)
          @Site.private_key = create_token(20, 4)
          @Site.user_id = @user.id
          @Site.id = (Site.maximum("id")).to_i + 1
          @Site.global_site = 1
          @Site.widget_type = 'SMS'
          @Site.inmediate_voice_fallback = 0
          @Site.use_unicode_support = 1
          @Site.app_type = 'WEBSITE'
          @Site.has_auto_retry = 0
          @Site.duplicate_numbers = 1
          @Site.store_ids = 'a:0:{}'
          @Site.app_schemes = 'a:0:{}'
          @Site.app_data = 'a:0:{}'

          @Site.save
          respond_to do |format|
            format.js {render inline: "<script>location.reload();</script>" }
          end
        else
          render :web_sub, :layout => false
        end

      elsif @appType == 'MOBILE'
        @app_name = params[:create_app][:appName]
        @fallback = params[:create_app][:unavailablePlatformFallbackUrl]

        #if valid create app
        if !@isInvalid && (!@app_name.to_s.strip.empty?)
          @Site = Site.new
          @user = current_user
          @Site.app_name = @app_name
          @Site.site_key = create_token(20, 4)
          @Site.private_key = create_token(20, 4)
          @Site.user_id = @user.id
          @Site.id = (Site.maximum("id")).to_i + 1
          @Site.global_site = 1
          @Site.widget_type = 'SMS'
          @Site.inmediate_voice_fallback = 0
          @Site.use_unicode_support = 1
          @Site.app_type = 'MOBILE'
          @Site.has_auto_retry = 0
          @Site.duplicate_numbers = 1

          my_scheme_ios = params[:create_app][:appSchemes][:ios]
          my_id_ios = params[:create_app][:storeIds][:ios]

          my_scheme_android = params[:create_app][:appSchemes][:android]
          my_id_android = params[:create_app][:storeIds][:android]

          @Site.store_ids = 'a:0:{}'
          @Site.app_schemes = 'a:0:{}'
          @Site.app_data = 'a:0:{}'

          setter_boolONE = false
          setter_boolTWO = false

          unless my_scheme_ios.to_s.strip.empty?
            ios_scheme = my_scheme_ios
            setter_boolONE = true
          else
            ios_scheme = "N"
          end

          unless my_id_ios.to_s.strip.empty?
            ios_id = my_id_ios
            setter_boolTWO = true
          else
            ios_id = "N"
          end

          unless my_scheme_android.to_s.strip.empty?
            android_scheme = my_scheme_android
            setter_boolONE = true
          else
            android_scheme = "N"
          end

          unless my_id_android.to_s.strip.empty?
            android_id = my_id_android
            setter_boolTWO = true
          else
            android_id = "N"
          end

          if setter_boolONE
            #p ios_scheme.eql? "N"
            if ios_scheme.eql? "N"
              ios_p = %(s:3:"ios";#{ios_scheme};)
            else
              ios_p = %(s:3:"ios";s:#{ios_scheme.length}:"#{ios_scheme}";)
            end
            if android_scheme.eql? "N"
              android_p = %(s:7:"android";#{android_scheme};)
            else
              android_p = %(s:7:"android";s:#{android_scheme.length}:"#{android_scheme}";)
            end

            @Site.app_schemes = %(a:2:{#{ios_p}#{android_p}})
          end

          if setter_boolTWO
            if ios_id.eql? "N"
              ios_p2 = %(s:3:"ios";#{ios_id};)
            else
              ios_p2 = %(s:3:"ios";s:#{ios_id.length}:"#{ios_id}";)
            end
            if android_id.eql? "N"
              android_p2 = %(s:7:"android";#{android_id};)
            else
              android_p2 = %(s:7:"android";s:#{android_id.length}:"#{android_id}";)
            end
            @Site.store_ids = %(a:2:{#{ios_p2}#{android_p2}})
          end

          @Site.unavailable_platform_fallback_url = @fallback

          @Site.save
          respond_to do |format|
            format.js {render inline: "<script>location.reload();</script>" }
          end
        else
          render :mobile_sub, :layout => false
        end

      elsif @appType == 'ONBOARDING'
        @app_name = params[:create_app][:appName]
        @fallback = params[:create_app][:unavailablePlatformFallbackUrl]
        @domain = params[:create_app][:domain]

        #if valid create app
        if !@isInvalid && (!@app_name.to_s.strip.empty?) && (!@domain.to_s.strip.empty?)
          @Site = Site.new
          @user = current_user
          @Site.app_name = @app_name
          @Site.site_key = create_token(20, 4)
          @Site.private_key = create_token(20, 4)
          @Site.user_id = @user.id
          @Site.id = (Site.maximum("id")).to_i + 1
          @Site.global_site = 1
          @Site.widget_type = 'SMS'
          @Site.inmediate_voice_fallback = 0
          @Site.use_unicode_support = 1
          @Site.app_type = 'ONBOARDING'
          @Site.has_auto_retry = 0
          @Site.duplicate_numbers = 1
          @Site.domain = @domain

          my_scheme_ios = params[:create_app][:appSchemes][:ios]
          my_id_ios = params[:create_app][:storeIds][:ios]

          my_scheme_android = params[:create_app][:appSchemes][:android]
          my_id_android = params[:create_app][:storeIds][:android]

          @Site.store_ids = 'a:0:{}'
          @Site.app_schemes = 'a:0:{}'
          @Site.app_data = 'a:0:{}'

          setter_boolONE = false
          setter_boolTWO = false

          unless my_scheme_ios.to_s.strip.empty?
            ios_scheme = my_scheme_ios
            setter_boolONE = true
          else
            ios_scheme = "N"
          end

          unless my_id_ios.to_s.strip.empty?
            ios_id = my_id_ios
            setter_boolTWO = true
          else
            ios_id = "N"
          end

          unless my_scheme_android.to_s.strip.empty?
            android_scheme = my_scheme_android
            setter_boolONE = true
          else
            android_scheme = "N"
          end

          unless my_id_android.to_s.strip.empty?
            android_id = my_id_android
            setter_boolTWO = true
          else
            android_id = "N"
          end

          if setter_boolONE
            #p ios_scheme.eql? "N"
            if ios_scheme.eql? "N"
              ios_p = %(s:3:"ios";#{ios_scheme};)
            else
              ios_p = %(s:3:"ios";s:#{ios_scheme.length}:"#{ios_scheme}";)
            end
            if android_scheme.eql? "N"
              android_p = %(s:7:"android";#{android_scheme};)
            else
              android_p = %(s:7:"android";s:#{android_scheme.length}:"#{android_scheme}";)
            end

            @Site.app_schemes = %(a:2:{#{ios_p}#{android_p}})
          end

          if setter_boolTWO
            if ios_id.eql? "N"
              ios_p2 = %(s:3:"ios";#{ios_id};)
            else
              ios_p2 = %(s:3:"ios";s:#{ios_id.length}:"#{ios_id}";)
            end
            if android_id.eql? "N"
              android_p2 = %(s:7:"android";#{android_id};)
            else
              android_p2 = %(s:7:"android";s:#{android_id.length}:"#{android_id}";)
            end
            @Site.store_ids = %(a:2:{#{ios_p2}#{android_p2}})
          end

          @Site.unavailable_platform_fallback_url = @fallback

          @Site.save
          respond_to do |format|
            format.js {render inline: "<script>location.reload();</script>" }
          end
        else
          render :onboarding_sub, :layout => false
        end
      else
        render :create, :layout => false
      end
    end
  end

  def edit
    if request.xhr?
      app_id = params[:id]
      @user_site = Site.find(app_id)

      #post requests return
      if request.post?
        @appType = params[:edit_app][:appType]
        @isInvalid = params[:isInvalid]

        if !@user_site.domain
          @user_site.domain = ''
        end

        if @appType == 'WEBSITE' || @appType == 'DISTRIBUTION'
          @domain = params[:edit_app][:domain]

          #if valid create app
          if !@isInvalid && (!@domain.to_s.strip.empty?)

            @user_site.domain = @domain
            @user_site.save

            respond_to do |format|
              format.js {render inline: "<script>location.reload();</script>" }
            end
          else
            render :website_edit, :layout => false
          end

        elsif @appType == 'MOBILE'

          @app_name = params[:edit_app][:appName]
          @fallback = params[:edit_app][:unavailablePlatformFallbackUrl]

          #if valid create app
          if !@isInvalid && (!@app_name.to_s.strip.empty?)
            @user_site.app_name = @app_name

            my_scheme_ios = params[:edit_app][:appSchemes][:ios]
            my_id_ios = params[:edit_app][:storeIds][:ios]

            my_scheme_android = params[:edit_app][:appSchemes][:android]
            my_id_android = params[:edit_app][:storeIds][:android]

            @user_site.store_ids = 'a:0:{}'
            @user_site.app_schemes = 'a:0:{}'
            @user_site.app_data = 'a:0:{}'

            setter_boolONE = false
            setter_boolTWO = false

            unless my_scheme_ios.to_s.strip.empty?
              ios_scheme = my_scheme_ios
              setter_boolONE = true
            else
              ios_scheme = "N"
            end

            unless my_id_ios.to_s.strip.empty?
              ios_id = my_id_ios
              setter_boolTWO = true
            else
              ios_id = "N"
            end

            unless my_scheme_android.to_s.strip.empty?
              android_scheme = my_scheme_android
              setter_boolONE = true
            else
              android_scheme = "N"
            end

            unless my_id_android.to_s.strip.empty?
              android_id = my_id_android
              setter_boolTWO = true
            else
              android_id = "N"
            end

            if setter_boolONE
              #p ios_scheme.eql? "N"
              if ios_scheme.eql? "N"
                ios_p = %(s:3:"ios";#{ios_scheme};)
              else
                ios_p = %(s:3:"ios";s:#{ios_scheme.length}:"#{ios_scheme}";)
              end
              if android_scheme.eql? "N"
                android_p = %(s:7:"android";#{android_scheme};)
              else
                android_p = %(s:7:"android";s:#{android_scheme.length}:"#{android_scheme}";)
              end

              @user_site.app_schemes = %(a:2:{#{ios_p}#{android_p}})
            end

            if setter_boolTWO
              if ios_id.eql? "N"
                ios_p2 = %(s:3:"ios";#{ios_id};)
              else
                ios_p2 = %(s:3:"ios";s:#{ios_id.length}:"#{ios_id}";)
              end
              if android_id.eql? "N"
                android_p2 = %(s:7:"android";#{android_id};)
              else
                android_p2 = %(s:7:"android";s:#{android_id.length}:"#{android_id}";)
              end
              @user_site.store_ids = %(a:2:{#{ios_p2}#{android_p2}})
            end

            @user_site.unavailable_platform_fallback_url = @fallback

            @user_site.save
            respond_to do |format|
              format.js {render inline: "<script>location.reload();</script>" }
            end
          else

            send_to = @user_site
            @user_site = parse_schema(send_to)
            render :mobile_edit, :layout => false
          end

        elsif @appType == 'ONBOARDING'
          @app_name = params[:edit_app][:appName]
          @fallback = params[:edit_app][:unavailablePlatformFallbackUrl]
          @domain = params[:edit_app][:domain]

          #if valid create app
          if !@isInvalid && (!@app_name.to_s.strip.empty?) && (!@domain.to_s.strip.empty?)

            @user_site.app_name = @app_name
            @user_site.domain = @domain

            my_scheme_ios = params[:edit_app][:appSchemes][:ios]
            my_id_ios = params[:edit_app][:storeIds][:ios]

            my_scheme_android = params[:edit_app][:appSchemes][:android]
            my_id_android = params[:edit_app][:storeIds][:android]

            @user_site.store_ids = 'a:0:{}'
            @user_site.app_schemes = 'a:0:{}'
            @user_site.app_data = 'a:0:{}'

            setter_boolONE = false
            setter_boolTWO = false

            unless my_scheme_ios.to_s.strip.empty?
              ios_scheme = my_scheme_ios
              setter_boolONE = true
            else
              ios_scheme = "N"
            end

            unless my_id_ios.to_s.strip.empty?
              ios_id = my_id_ios
              setter_boolTWO = true
            else
              ios_id = "N"
            end

            unless my_scheme_android.to_s.strip.empty?
              android_scheme = my_scheme_android
              setter_boolONE = true
            else
              android_scheme = "N"
            end

            unless my_id_android.to_s.strip.empty?
              android_id = my_id_android
              setter_boolTWO = true
            else
              android_id = "N"
            end

            if setter_boolONE
              #p ios_scheme.eql? "N"
              if ios_scheme.eql? "N"
                ios_p = %(s:3:"ios";#{ios_scheme};)
              else
                ios_p = %(s:3:"ios";s:#{ios_scheme.length}:"#{ios_scheme}";)
              end
              if android_scheme.eql? "N"
                android_p = %(s:7:"android";#{android_scheme};)
              else
                android_p = %(s:7:"android";s:#{android_scheme.length}:"#{android_scheme}";)
              end

              @user_site.app_schemes = %(a:2:{#{ios_p}#{android_p}})
            end

            if setter_boolTWO
              if ios_id.eql? "N"
                ios_p2 = %(s:3:"ios";#{ios_id};)
              else
                ios_p2 = %(s:3:"ios";s:#{ios_id.length}:"#{ios_id}";)
              end
              if android_id.eql? "N"
                android_p2 = %(s:7:"android";#{android_id};)
              else
                android_p2 = %(s:7:"android";s:#{android_id.length}:"#{android_id}";)
              end
              @user_site.store_ids = %(a:2:{#{ios_p2}#{android_p2}})
            end

            @user_site.unavailable_platform_fallback_url = @fallback

            @user_site.save
            respond_to do |format|
              format.js {render inline: "<script>location.reload();</script>" }
            end
          else
            send_to = @user_site
            @user_site = parse_schema(send_to)
            render :onboarding_edit, :layout => false
          end

        end

        # get requests returns
      else
        if @user_site.app_type == 'WEBSITE' || @user_site.app_type == 'DISTRIBUTION'
          render :website_edit, :layout => false

        elsif @user_site.app_type == 'MOBILE'

          send_to = @user_site
          @user_site = parse_schema(send_to)
          render :mobile_edit, :layout => false

        elsif @user_site.app_type == 'ONBOARDING'
          send_to = @user_site
          @user_site = parse_schema(send_to)
          render :onboarding_edit, :layout => false
        end
      end

    end
  end

  def custom
    if request.xhr?
      app_id = params[:id]
      @user_site = Site.find(app_id)
      if @user_site.domain
        @site_name = (@user_site.domain.to_s.split(","))[0]
      else
        @site_name = @user_site.app_name
      end

      @whitelist = Whitelist.where(site_id: app_id)
      @blacklist = Blacklist.where(site_id: app_id)
      @app_countries = EnabledCountry.where(app_id: app_id)
      @country_list = country_map("give_full_map")

      #p clean_number("+08062562272")

      @out_put_country = Array.new
      for item in @app_countries
        @out_put_country.push(item.country_iso.squeeze(' ').strip)
      end

      if @user_site.custom_message

        to_rb = JSON.parse(@user_site.custom_message)
        @custom_message = to_rb
        @lang_array = Array.new
        for item in to_rb["verification"]
          out_put = {item[0] => item[1], :language => language_map(item[0])}
          @lang_array.push(out_put)
        end

      else
        @custom_message = @site_name + " PIN: {{ code }}. Or you can tap on this link to verify your device: {{ link }}."
      end

      render :layout => false
    end
  end

  def custom_post
    if request.xhr?
      app_id = params[:id]
      @user_site = Site.find(app_id)

      #params
      custom_sender = params[:customize][:sender]
      custom_message = params[:customize][:messages]
      custom_session_timer = params[:customize][:token_expiry]
      max_verifications_allowed = custom_session_timer = params[:customize][:max_verifications_allowed]
      whitelist = params[:customize][:whitelist]
      blacklist = params[:customize][:blacklist]
      countries = params[:customize][:countries]

      if whitelist
        Whitelist.destroy_all "site_id = #{@user_site.id}"

        for item in whitelist
          take_apart = whitelist[item]
          @new_list = Whitelist.new

          @new_list.cleansed_number = clean_number(take_apart["phone"])
          @new_list.description = take_apart["description"]
          @new_list.verifications_allowed = take_apart["max_verifications"]
          @new_list.site_id = app_id
          @new_list.id = (Whitelist.maximum("id")).to_i + 1
          @new_list.save
        end
      end

      if blacklist
        Blacklist.destroy_all "site_id = #{@user_site.id}"

        for item in blacklist
          take_apart = blacklist[item]
          @new_list = Blacklist.new

          @new_list.cleaned_number = clean_number(take_apart["phone"])
          @new_list.blacklist_reason = take_apart["description"]
          @new_list.site_id = app_id
          @new_list.is_active = 1
          @new_list.id = (Blacklist.maximum("id")).to_i + 1
          @new_list.save
        end
      end

      if countries
        EnabledCountry.destroy_all "app_id = #{@user_site.id}"

        counter = (EnabledCountry.maximum("id")).to_i + 1
        for item in countries
          @new_country = EnabledCountry.new

          @new_country.app_id = app_id
          @new_country.id = counter
          @new_country.country_iso = item
          p @new_country
          counter = counter + 1
          @new_country.save
        end
      end


      #{"phone"=>"11", "description"=>"aa", "max_verifications"=>"afa"}

      @user_site.custom_sender_id = custom_sender

      output_array = Array.new
      custom_message_ver = custom_message[:verification]
      for item in custom_message_ver
        template = custom_message_ver[item][:template]
        language = custom_message_ver[item][:language]
        output = '"' + "#{language}" +'": ' + '"' + "#{template}" + '"'
        output_array.push(output)
      end

      on_nested = "\"en\": \"Download #{@user_site.app_name} here: {{ link }} powered by #{@user_site.app_name}\""
      dis_nested = "\"en\": \"Download #{@user_site.app_name} here: {{ link }} and use this code to activate: {{ code }}.\""

      message_hash = "{\"verification\": {" + output_array.join(",") + "}," +
         "\"onboarding\": {" + on_nested + "}," +
         "\"distribution\": {" + dis_nested + "}}"

      @user_site.custom_message = message_hash
      @user_site.custom_session_timer = custom_session_timer

      #TODO: double check where max_verifications go in database
      #block_blacklist and custom_retry_timer
      #@user_site.custom_retry_timer = max_verifications_allowed

      @user_site.save
      respond_to do |format|
        format.js {render inline: "<script>location.reload();</script>" }
      end
    end
  end

  def delete
    app_id = params[:id]
    @user_site = Site.find(app_id)
    if @user_site.user_id == current_user.id
      @user_site.delete
    end
    redirect_to :back
  end

  def instructions
    if request.xhr?
      app_id = params[:id]
      @user_site = Site.find(app_id)
      if @user_site.app_type == "WEBSITE"
        render :website_doc, :layout => false
      elsif @user_site.app_type == "MOBILE"
        render :mobile_doc, :layout => false
      elsif @user_site.app_type == "ONBOARDING"
        render :onboarding_doc, :layout => false
      end
    end
  end

  private

  def create_token (key_length, key_strength)
    @vowels = 'aeuioy';
    @consonants = 'bcdfghjklmnpqrstvzbcdfghjklmnpqrstvz';

    if key_strength == 1
      @consonants += 'BDGHJLMNPQRSTVWXZ'
    end

    if key_strength == 2
      @vowels += 'AEUY'
    end

    if key_strength == 4
      @consonants += '123456789123456789123456789123456789'
    end

    if key_strength == 8
      @consonants += '@#$%'
    end

    if key_strength == 9
      @consonants += 'BDGHJLMNPQRSTVWXZ@#$%23456789'
    end

    @password = ''
    @alt = rand(1..2)

    $i = 0
    while $i < key_length  do

      if @alt == 1
        @password += @consonants[rand(1..10000) % @consonants.length]
        @alt = 0
      else
        @password += @vowels[rand(1..10000) % @vowels.length]
        @alt = 1
      end

      $i +=1
    end

    return @password

  end

  def parse_schema (send_to)
    #start parsing values
    if send_to.app_schemes == "a:0:{}"
      @ios_scheme = ""
      @android_scheme = ""
    else

      ios_scheme_1 = send_to.app_schemes[send_to.app_schemes.index('ios"')+7, send_to.app_schemes.index('"android')-7]
      index_track = ios_scheme_1
      index_find = (0 ... index_track.length).find_all { |i| index_track[i,1] == '"' }
      if index_track.index('N;')
        @ios_scheme = ""
      else
        @ios_scheme = index_track[index_find[0] + 1, index_find[1] -3]
        if @ios_scheme.index("android")
          @ios_scheme = ""
        end
      end

      android_scheme_1 = send_to.app_schemes[send_to.app_schemes.index('android"') + 9, send_to.app_schemes.length]
      index_track2 = android_scheme_1
      index_find_a = (0 ... index_track2.length).find_all { |i| index_track2[i,1] == '"' }
      if index_track2.index('N;')
        @android_scheme = ""
      else
        @android_scheme = index_track2[index_find_a[0] + 1, index_find_a[1] -5]
      end

      if send_to.store_ids == "a:0:{}"
        @ios_id = ""
        @android_id = ""
      else

        ios_scheme_1 = send_to.store_ids[send_to.store_ids.index('ios"')+7, send_to.store_ids.index('"android')-7]
        index_track = ios_scheme_1
        index_find = (0 ... index_track.length).find_all { |i| index_track[i,1] == '"' }
        if index_track.index('N;')
          @ios_id = ""
        else
          @ios_id = index_track[index_find[0] + 1, index_find[1] -3]
          if @ios_id.index("android")
            @ios_id = ""
          end
        end

        android_scheme_1 = send_to.store_ids[send_to.store_ids.index('android"') + 9, send_to.store_ids.length]
        index_track2 = android_scheme_1
        index_find_a = (0 ... index_track2.length).find_all { |i| index_track2[i,1] == '"' }
        if index_track2.index('N;')
          @android_id = ""
        else
          @android_id = index_track2[index_find_a[0] + 1, index_find_a[1] -5]
        end

      end


    end

    return send_to
    #end parse
  end

  #this requires users to add international extension
  def clean_number (number)

    is_international = false
    if number.include? "+"
      is_international = true
    end

    str = number.gsub(/[^\d,\.]/, '')

    if str[0] == '0'
      str = str[1..-1]
    end

    phone = Phonelib.parse(str)

    if is_international
      return phone.international(false)
    else
      return phone.national(false)
    end
  end

  def language_map (code)
    language = {"ab"=>"Abkhazian",
    "ace"=>"Achinese",
    "ach"=>"Acoli",
    "ada"=>"Adangme",
    "ady"=>"Adyghe",
    "aa"=>"Afar",
    "afh"=>"Afrihili",
    "af"=>"Afrikaans",
    "agq"=>"Aghem",
    "ain"=>"Ainu",
    "ak"=>"Akan",
    "akk"=>"Akkadian",
    "bss"=>"Akoose",
    "akz"=>"Alabama",
    "sq"=>"Albanian",
    "ale"=>"Aleut",
    "arq"=>"Algerian Arabic",
    "en_US"=>"American English",
    "ase"=>"American Sign Language",
    "am"=>"Amharic",
    "egy"=>"Ancient Egyptian",
    "grc"=>"Ancient Greek",
    "anp"=>"Angika",
    "njo"=>"Ao Naga",
    "ar"=>"Arabic",
    "an"=>"Aragonese",
    "arc"=>"Aramaic",
    "aro"=>"Araona",
    "arp"=>"Arapaho",
    "arw"=>"Arawak",
    "hy"=>"Armenian",
    "rup"=>"Aromanian",
    "frp"=>"Arpitan",
    "as"=>"Assamese",
    "ast"=>"Asturian",
    "asa"=>"Asu",
    "cch"=>"Atsam",
    "en_AU"=>"Australian English",
    "de_AT"=>"Austrian German",
    "av"=>"Avaric",
    "ae"=>"Avestan",
    "awa"=>"Awadhi",
    "ay"=>"Aymara",
    "az"=>"Azerbaijani",
    "bfq"=>"Badaga",
    "ksf"=>"Bafia",
    "bfd"=>"Bafut",
    "bqi"=>"Bakhtiari",
    "ban"=>"Balinese",
    "bal"=>"Baluchi",
    "bm"=>"Bambara",
    "bax"=>"Bamun",
    "bjn"=>"Banjar",
    "bas"=>"Basaa",
    "ba"=>"Bashkir",
    "eu"=>"Basque",
    "bbc"=>"Batak Toba",
    "bar"=>"Bavarian",
    "bej"=>"Beja",
    "be"=>"Belarusian",
    "bem"=>"Bemba",
    "bez"=>"Bena",
    "bn"=>"Bengali",
    "bew"=>"Betawi",
    "bho"=>"Bhojpuri",
    "bik"=>"Bikol",
    "bin"=>"Bini",
    "bpy"=>"Bishnupriya",
    "bi"=>"Bislama",
    "byn"=>"Blin",
    "zbl"=>"Blissymbols",
    "brx"=>"Bodo",
    "bs"=>"Bosnian",
    "brh"=>"Brahui",
    "bra"=>"Braj",
    "pt_BR"=>"Brazilian Portuguese",
    "br"=>"Breton",
    "en_GB"=>"British English",
    "bug"=>"Buginese",
    "bg"=>"Bulgarian",
    "bum"=>"Bulu",
    "bua"=>"Buriat",
    "my"=>"Burmese",
    "cad"=>"Caddo",
    "frc"=>"Cajun French",
    "en_CA"=>"Canadian English",
    "fr_CA"=>"Canadian French",
    "yue"=>"Cantonese",
    "cps"=>"Capiznon",
    "car"=>"Carib",
    "ca"=>"Catalan",
    "cay"=>"Cayuga",
    "ceb"=>"Cebuano",
    "tzm"=>"Central Atlas Tamazight",
    "dtp"=>"Central Dusun",
    "esu"=>"Central Yupik",
    "shu"=>"Chadian Arabic",
    "chg"=>"Chagatai",
    "ch"=>"Chamorro",
    "ce"=>"Chechen",
    "chr"=>"Cherokee",
    "chy"=>"Cheyenne",
    "chb"=>"Chibcha",
    "cgg"=>"Chiga",
    "qug"=>"Chimborazo Highland Quichua",
    "zh"=>"Chinese",
    "chn"=>"Chinook Jargon",
    "chp"=>"Chipewyan",
    "cho"=>"Choctaw",
    "cu"=>"Church Slavic",
    "chk"=>"Chuukese",
    "cv"=>"Chuvash",
    "nwc"=>"Classical Newari",
    "syc"=>"Classical Syriac",
    "ksh"=>"Colognian",
    "swb"=>"Comorian",
    "swc"=>"Congo Swahili",
    "cop"=>"Coptic",
    "kw"=>"Cornish",
    "co"=>"Corsican",
    "cr"=>"Cree",
    "mus"=>"Creek",
    "crh"=>"Crimean Turkish",
    "hr"=>"Croatian",
    "cs"=>"Czech",
    "dak"=>"Dakota",
    "da"=>"Danish",
    "dar"=>"Dargwa",
    "dzg"=>"Dazaga",
    "del"=>"Delaware",
    "din"=>"Dinka",
    "dv"=>"Divehi",
    "doi"=>"Dogri",
    "dgr"=>"Dogrib",
    "dua"=>"Duala",
    "nl"=>"Dutch",
    "dyu"=>"Dyula",
    "dz"=>"Dzongkha",
    "frs"=>"Eastern Frisian",
    "efi"=>"Efik",
    "arz"=>"Egyptian Arabic",
    "eka"=>"Ekajuk",
    "elx"=>"Elamite",
    "ebu"=>"Embu",
    "egl"=>"Emilian",
    "en"=>"English",
    "myv"=>"Erzya",
    "eo"=>"Esperanto",
    "et"=>"Estonian",
    "pt_PT"=>"European Portuguese",
    "es_ES"=>"European Spanish",
    "ee"=>"Ewe",
    "ewo"=>"Ewondo",
    "ext"=>"Extremaduran",
    "fan"=>"Fang",
    "fat"=>"Fanti",
    "fo"=>"Faroese",
    "hif"=>"Fiji Hindi",
    "fj"=>"Fijian",
    "fil"=>"Filipino",
    "fi"=>"Finnish",
    "nl_BE"=>"Flemish",
    "fon"=>"Fon",
    "gur"=>"Frafra",
    "fr"=>"French",
    "fur"=>"Friulian",
    "ff"=>"Fulah",
    "gaa"=>"Ga",
    "gag"=>"Gagauz",
    "gl"=>"Galician",
    "gan"=>"Gan Chinese",
    "lg"=>"Ganda",
    "gay"=>"Gayo",
    "gba"=>"Gbaya",
    "gez"=>"Geez",
    "ka"=>"Georgian",
    "de"=>"German",
    "aln"=>"Gheg Albanian",
    "bbj"=>"Ghomala",
    "glk"=>"Gilaki",
    "gil"=>"Gilbertese",
    "gom"=>"Goan Konkani",
    "gon"=>"Gondi",
    "gor"=>"Gorontalo",
    "got"=>"Gothic",
    "grb"=>"Grebo",
    "el"=>"Greek",
    "gn"=>"Guarani",
    "gu"=>"Gujarati",
    "guz"=>"Gusii",
    "gwi"=>"Gwichʼin",
    "hai"=>"Haida",
    "ht"=>"Haitian",
    "hak"=>"Hakka Chinese",
    "ha"=>"Hausa",
    "haw"=>"Hawaiian",
    "he"=>"Hebrew",
    "hz"=>"Herero",
    "hil"=>"Hiligaynon",
    "hi"=>"Hindi",
    "ho"=>"Hiri Motu",
    "hit"=>"Hittite",
    "hmn"=>"Hmong",
    "hu"=>"Hungarian",
    "hup"=>"Hupa",
    "iba"=>"Iban",
    "ibb"=>"Ibibio",
    "is"=>"Icelandic",
    "io"=>"Ido",
    "ig"=>"Igbo",
    "ilo"=>"Iloko",
    "smn"=>"Inari Sami",
    "id"=>"Indonesian",
    "izh"=>"Ingrian",
    "inh"=>"Ingush",
    "ia"=>"Interlingua",
    "ie"=>"Interlingue",
    "iu"=>"Inuktitut",
    "ik"=>"Inupiaq",
    "ga"=>"Irish",
    "it"=>"Italian",
    "jam"=>"Jamaican Creole English",
    "ja"=>"Japanese",
    "jv"=>"Javanese",
    "kaj"=>"Jju",
    "dyo"=>"Jola-Fonyi",
    "jrb"=>"Judeo-Arabic",
    "jpr"=>"Judeo-Persian",
    "jut"=>"Jutish",
    "kbd"=>"Kabardian",
    "kea"=>"Kabuverdianu",
    "kab"=>"Kabyle",
    "kac"=>"Kachin",
    "kgp"=>"Kaingang",
    "kkj"=>"Kako",
    "kl"=>"Kalaallisut",
    "kln"=>"Kalenjin",
    "xal"=>"Kalmyk",
    "kam"=>"Kamba",
    "kbl"=>"Kanembu",
    "kn"=>"Kannada",
    "kr"=>"Kanuri",
    "kaa"=>"Kara-Kalpak",
    "krc"=>"Karachay-Balkar",
    "krl"=>"Karelian",
    "ks"=>"Kashmiri",
    "csb"=>"Kashubian",
    "kaw"=>"Kawi",
    "kk"=>"Kazakh",
    "ken"=>"Kenyang",
    "kha"=>"Khasi",
    "km"=>"Khmer",
    "kho"=>"Khotanese",
    "khw"=>"Khowar",
    "ki"=>"Kikuyu",
    "kmb"=>"Kimbundu",
    "krj"=>"Kinaray-a",
    "rw"=>"Kinyarwanda",
    "kiu"=>"Kirmanjki",
    "tlh"=>"Klingon",
    "bkm"=>"Kom",
    "kv"=>"Komi",
    "koi"=>"Komi-Permyak",
    "kg"=>"Kongo",
    "kok"=>"Konkani",
    "ko"=>"Korean",
    "kfo"=>"Koro",
    "kos"=>"Kosraean",
    "avk"=>"Kotava",
    "khq"=>"Koyra Chiini",
    "ses"=>"Koyraboro Senni",
    "kpe"=>"Kpelle",
    "kri"=>"Krio",
    "kj"=>"Kuanyama",
    "kum"=>"Kumyk",
    "ku"=>"Kurdish",
    "kru"=>"Kurukh",
    "kut"=>"Kutenai",
    "nmg"=>"Kwasio",
    "ky"=>"Kyrgyz",
    "quc"=>"Kʼicheʼ",
    "lad"=>"Ladino",
    "lah"=>"Lahnda",
    "lkt"=>"Lakota",
    "lam"=>"Lamba",
    "lag"=>"Langi",
    "lo"=>"Lao",
    "ltg"=>"Latgalian",
    "la"=>"Latin",
    "es_419"=>"Latin American Spanish",
    "lv"=>"Latvian",
    "lzz"=>"Laz",
    "lez"=>"Lezghian",
    "lij"=>"Ligurian",
    "li"=>"Limburgish",
    "ln"=>"Lingala",
    "lfn"=>"Lingua Franca Nova",
    "lzh"=>"Literary Chinese",
    "lt"=>"Lithuanian",
    "liv"=>"Livonian",
    "jbo"=>"Lojban",
    "lmo"=>"Lombard",
    "nds"=>"Low German",
    "sli"=>"Lower Silesian",
    "dsb"=>"Lower Sorbian",
    "loz"=>"Lozi",
    "lu"=>"Luba-Katanga",
    "lua"=>"Luba-Lulua",
    "lui"=>"Luiseno",
    "smj"=>"Lule Sami",
    "lun"=>"Lunda",
    "luo"=>"Luo",
    "lb"=>"Luxembourgish",
    "luy"=>"Luyia",
    "mde"=>"Maba",
    "mk"=>"Macedonian",
    "jmc"=>"Machame",
    "mad"=>"Madurese",
    "maf"=>"Mafa",
    "mag"=>"Magahi",
    "vmf"=>"Main-Franconian",
    "mai"=>"Maithili",
    "mak"=>"Makasar",
    "mgh"=>"Makhuwa-Meetto",
    "kde"=>"Makonde",
    "mg"=>"Malagasy",
    "ms"=>"Malay",
    "ml"=>"Malayalam",
    "mt"=>"Maltese",
    "mnc"=>"Manchu",
    "mdr"=>"Mandar",
    "man"=>"Mandingo",
    "mni"=>"Manipuri",
    "gv"=>"Manx",
    "mi"=>"Maori",
    "arn"=>"Mapuche",
    "mr"=>"Marathi",
    "chm"=>"Mari",
    "mh"=>"Marshallese",
    "mwr"=>"Marwari",
    "mas"=>"Masai",
    "mzn"=>"Mazanderani",
    "byv"=>"Medumba",
    "men"=>"Mende",
    "mwv"=>"Mentawai",
    "mer"=>"Meru",
    "mgo"=>"Metaʼ",
    "es_MX"=>"Mexican Spanish",
    "mic"=>"Micmac",
    "dum"=>"Middle Dutch",
    "enm"=>"Middle English",
    "frm"=>"Middle French",
    "gmh"=>"Middle High German",
    "mga"=>"Middle Irish",
    "nan"=>"Min Nan Chinese",
    "min"=>"Minangkabau",
    "xmf"=>"Mingrelian",
    "mwl"=>"Mirandese",
    "lus"=>"Mizo",
    "ar_001"=>"Modern Standard Arabic",
    "moh"=>"Mohawk",
    "mdf"=>"Moksha",
    "ro_MD"=>"Moldavian",
    "lol"=>"Mongo",
    "mn"=>"Mongolian",
    "mfe"=>"Morisyen",
    "ary"=>"Moroccan Arabic",
    "mos"=>"Mossi",
    "mul"=>"Multiple Languages",
    "mua"=>"Mundang",
    "ttt"=>"Muslim Tat",
    "mye"=>"Myene",
    "naq"=>"Nama",
    "na"=>"Nauru",
    "nv"=>"Navajo",
    "ng"=>"Ndonga",
    "nap"=>"Neapolitan",
    "ne"=>"Nepali",
    "new"=>"Newari",
    "sba"=>"Ngambay",
    "nnh"=>"Ngiemboon",
    "jgo"=>"Ngomba",
    "yrl"=>"Nheengatu",
    "nia"=>"Nias",
    "niu"=>"Niuean",
    "zxx"=>"No linguistic content",
    "nog"=>"Nogai",
    "nd"=>"North Ndebele",
    "frr"=>"Northern Frisian",
    "se"=>"Northern Sami",
    "nso"=>"Northern Sotho",
    "no"=>"Norwegian",
    "nb"=>"Norwegian Bokmål",
    "nn"=>"Norwegian Nynorsk",
    "nov"=>"Novial",
    "nus"=>"Nuer",
    "nym"=>"Nyamwezi",
    "ny"=>"Nyanja",
    "nyn"=>"Nyankole",
    "tog"=>"Nyasa Tonga",
    "nyo"=>"Nyoro",
    "nzi"=>"Nzima",
    "nqo"=>"NʼKo",
    "oc"=>"Occitan",
    "oj"=>"Ojibwa",
    "ang"=>"Old English",
    "fro"=>"Old French",
    "goh"=>"Old High German",
    "sga"=>"Old Irish",
    "non"=>"Old Norse",
    "peo"=>"Old Persian",
    "pro"=>"Old Provençal",
    "or"=>"Oriya",
    "om"=>"Oromo",
    "osa"=>"Osage",
    "os"=>"Ossetic",
    "ota"=>"Ottoman Turkish",
    "pal"=>"Pahlavi",
    "pfl"=>"Palatine German",
    "pau"=>"Palauan",
    "pi"=>"Pali",
    "pam"=>"Pampanga",
    "pag"=>"Pangasinan",
    "pap"=>"Papiamento",
    "ps"=>"Pashto",
    "pdc"=>"Pennsylvania German",
    "fa"=>"Persian",
    "phn"=>"Phoenician",
    "pcd"=>"Picard",
    "pms"=>"Piedmontese",
    "pdt"=>"Plautdietsch",
    "pon"=>"Pohnpeian",
    "pl"=>"Polish",
    "pnt"=>"Pontic",
    "pt"=>"Portuguese",
    "prg"=>"Prussian",
    "pa"=>"Punjabi",
    "qu"=>"Quechua",
    "raj"=>"Rajasthani",
    "rap"=>"Rapanui",
    "rar"=>"Rarotongan",
    "rif"=>"Riffian",
    "rgn"=>"Romagnol",
    "ro"=>"Romanian",
    "rm"=>"Romansh",
    "rom"=>"Romany",
    "rof"=>"Rombo",
    "root"=>"Root",
    "rtm"=>"Rotuman",
    "rug"=>"Roviana",
    "rn"=>"Rundi",
    "ru"=>"Russian",
    "rue"=>"Rusyn",
    "rwk"=>"Rwa",
    "ssy"=>"Saho",
    "sah"=>"Sakha",
    "sam"=>"Samaritan Aramaic",
    "saq"=>"Samburu",
    "sm"=>"Samoan",
    "sgs"=>"Samogitian",
    "sad"=>"Sandawe",
    "sg"=>"Sango",
    "sbp"=>"Sangu",
    "sa"=>"Sanskrit",
    "sat"=>"Santali",
    "sc"=>"Sardinian",
    "sas"=>"Sasak",
    "sdc"=>"Sassarese Sardinian",
    "stq"=>"Saterland Frisian",
    "saz"=>"Saurashtra",
    "sco"=>"Scots",
    "gd"=>"Scottish Gaelic",
    "sly"=>"Selayar",
    "sel"=>"Selkup",
    "seh"=>"Sena",
    "see"=>"Seneca",
    "sr"=>"Serbian",
    "sh"=>"Serbo-Croatian",
    "srr"=>"Serer",
    "sei"=>"Seri",
    "ksb"=>"Shambala",
    "shn"=>"Shan",
    "sn"=>"Shona",
    "ii"=>"Sichuan Yi",
    "scn"=>"Sicilian",
    "sid"=>"Sidamo",
    "bla"=>"Siksika",
    "szl"=>"Silesian",
    "zh_Hans"=>"Simplified Chinese",
    "sd"=>"Sindhi",
    "si"=>"Sinhala",
    "sms"=>"Skolt Sami",
    "den"=>"Slave",
    "sk"=>"Slovak",
    "sl"=>"Slovenian",
    "xog"=>"Soga",
    "sog"=>"Sogdien",
    "so"=>"Somali",
    "snk"=>"Soninke",
    "ckb"=>"Sorani Kurdish",
    "azb"=>"South Azerbaijani",
    "nr"=>"South Ndebele",
    "alt"=>"Southern Altai",
    "sma"=>"Southern Sami",
    "st"=>"Southern Sotho",
    "es"=>"Spanish",
    "srn"=>"Sranan Tongo",
    "zgh"=>"Standard Moroccan Tamazight",
    "suk"=>"Sukuma",
    "sux"=>"Sumerian",
    "su"=>"Sundanese",
    "sus"=>"Susu",
    "sw"=>"Swahili",
    "ss"=>"Swati",
    "sv"=>"Swedish",
    "fr_CH"=>"Swiss French",
    "gsw"=>"Swiss German",
    "de_CH"=>"Swiss High German",
    "syr"=>"Syriac",
    "shi"=>"Tachelhit",
    "tl"=>"Tagalog",
    "ty"=>"Tahitian",
    "dav"=>"Taita",
    "tg"=>"Tajik",
    "tly"=>"Talysh",
    "tmh"=>"Tamashek",
    "ta"=>"Tamil",
    "trv"=>"Taroko",
    "twq"=>"Tasawaq",
    "tt"=>"Tatar",
    "te"=>"Telugu",
    "ter"=>"Tereno",
    "teo"=>"Teso",
    "tet"=>"Tetum",
    "th"=>"Thai",
    "bo"=>"Tibetan",
    "tig"=>"Tigre",
    "ti"=>"Tigrinya",
    "tem"=>"Timne",
    "tiv"=>"Tiv",
    "tli"=>"Tlingit",
    "tpi"=>"Tok Pisin",
    "tkl"=>"Tokelau",
    "to"=>"Tongan",
    "fit"=>"Tornedalen Finnish",
    "zh_Hant"=>"Traditional Chinese",
    "tkr"=>"Tsakhur",
    "tsd"=>"Tsakonian",
    "tsi"=>"Tsimshian",
    "ts"=>"Tsonga",
    "tn"=>"Tswana",
    "tcy"=>"Tulu",
    "tum"=>"Tumbuka",
    "aeb"=>"Tunisian Arabic",
    "tr"=>"Turkish",
    "tk"=>"Turkmen",
    "tru"=>"Turoyo",
    "tvl"=>"Tuvalu",
    "tyv"=>"Tuvinian",
    "tw"=>"Twi",
    "kcg"=>"Tyap",
    "udm"=>"Udmurt",
    "uga"=>"Ugaritic",
    "uk"=>"Ukrainian",
    "umb"=>"Umbundu",
    "und"=>"Unknown Language",
    "hsb"=>"Upper Sorbian",
    "ur"=>"Urdu",
    "ug"=>"Uyghur",
    "uz"=>"Uzbek",
    "vai"=>"Vai",
    "ve"=>"Venda",
    "vec"=>"Venetian",
    "vep"=>"Veps",
    "vi"=>"Vietnamese",
    "vo"=>"Volapük",
    "vro"=>"Võro",
    "vot"=>"Votic",
    "vun"=>"Vunjo",
    "wa"=>"Walloon",
    "wae"=>"Walser",
    "war"=>"Waray",
    "was"=>"Washo",
    "guc"=>"Wayuu",
    "cy"=>"Welsh",
    "vls"=>"West Flemish",
    "fy"=>"Western Frisian",
    "mrj"=>"Western Mari",
    "wal"=>"Wolaytta",
    "wo"=>"Wolof",
    "wuu"=>"Wu Chinese",
    "xh"=>"Xhosa",
    "hsn"=>"Xiang Chinese",
    "yav"=>"Yangben",
    "yao"=>"Yao",
    "yap"=>"Yapese",
    "ybb"=>"Yemba",
    "yi"=>"Yiddish",
    "yo"=>"Yoruba",
    "zap"=>"Zapotec",
    "dje"=>"Zarma",
    "zza"=>"Zaza",
    "zea"=>"Zeelandic",
    "zen"=>"Zenaga",
    "za"=>"Zhuang",
    "gbz"=>"Zoroastrian Dari",
    "zu"=>"Zulu",
    "zun"=>"Zuni"}

    if code == "give_full_map"
      return language
    else
      return language[code]
    end

  end

  def country_map (code)

    country = { "AF" => "Afghanistan",
      "AL" => "Albania",
      "DZ" => "Algeria",
      "AS" => "American Samoa",
      "AD" => "Andorra",
      "AO" => "Angola",
      "AI" => "Anguilla",
      "AQ" => "Antarctica",
      "AG" => "Antigua &amp; Barbuda",
      "AR" => "Argentina",
      "AM" => "Armenia",
      "AW" => "Aruba",
      "AU" => "Australia",
      "AT" => "Austria",
      "AZ" => "Azerbaijan",
      "BS" => "Bahamas",
      "BH" => "Bahrain",
      "BD" => "Bangladesh",
      "BB" => "Barbados",
      "BY" => "Belarus",
      "BE" => "Belgium",
      "BZ" => "Belize",
      "BJ" => "Benin",
      "BM" => "Bermuda",
      "BT" => "Bhutan",
      "BO" => "Bolivia",
      "BA" => "Bosnia &amp; Herzegovina",
      "BW" => "Botswana",
      "BR" => "Brazil",
      "IO" => "British Indian Ocean Territory",
      "VG" => "British Virgin Islands",
      "BN" => "Brunei",
      "BG" => "Bulgaria",
      "BF" => "Burkina Faso",
      "BI" => "Burundi",
      "KH" => "Cambodia",
      "CM" => "Cameroon",
      "CA" => "Canada",
      "CV" => "Cape Verde",
      "KY" => "Cayman Islands",
      "CF" => "Central African Republic",
      "TD" => "Chad",
      "CL" => "Chile",
      "CN" => "China",
      "CO" => "Colombia",
      "KM" => "Comoros",
      "CG" => "Congo - Brazzaville",
      "CD" => "Congo - Kinshasa",
      "CK" => "Cook Islands",
      "CR" => "Costa Rica",
      "CI" => "Côte d’Ivoire",
      "HR" => "Croatia",
      "CU" => "Cuba",
      "CY" => "Cyprus",
      "CZ" => "Czech Republic",
      "DK" => "Denmark",
      "DJ" => "Djibouti",
      "DM" => "Dominica",
      "DO" => "Dominican Republic",
      "EC" => "Ecuador",
      "EG" => "Egypt",
      "SV" => "El Salvador",
      "GQ" => "Equatorial Guinea",
      "ER" => "Eritrea",
      "EE" => "Estonia",
      "ET" => "Ethiopia",
      "FK" => "Falkland Islands",
      "FO" => "Faroe Islands",
      "FJ" => "Fiji",
      "FI" => "Finland",
      "FR" => "France",
      "GF" => "French Guiana",
      "PF" => "French Polynesia",
      "GA" => "Gabon",
      "GM" => "Gambia",
      "GE" => "Georgia",
      "DE" => "Germany",
      "GH" => "Ghana",
      "GI" => "Gibraltar",
      "GR" => "Greece",
      "GL" => "Greenland",
      "GD" => "Grenada",
      "GP" => "Guadeloupe",
      "GU" => "Guam",
      "GT" => "Guatemala",
      "GN" => "Guinea",
      "GW" => "Guinea-Bissau",
      "GY" => "Guyana",
      "HT" => "Haiti",
      "HN" => "Honduras",
      "HK" => "Hong Kong SAR China",
      "HU" => "Hungary",
      "IS" => "Iceland",
      "IN" => "India",
      "ID" => "Indonesia",
      "IR" => "Iran",
      "IQ" => "Iraq",
      "IE" => "Ireland",
      "IL" => "Israel",
      "IT" => "Italy",
      "JM" => "Jamaica",
      "JP" => "Japan",
      "JO" => "Jordan",
      "KZ" => "Kazakhstan",
      "KE" => "Kenya",
      "KI" => "Kiribati",
      "KW" => "Kuwait",
      "KG" => "Kyrgyzstan",
      "LA" => "Laos",
      "LV" => "Latvia",
      "LB" => "Lebanon",
      "LS" => "Lesotho",
      "LR" => "Liberia",
      "LY" => "Libya",
      "LI" => "Liechtenstein",
      "LT" => "Lithuania",
      "LU" => "Luxembourg",
      "MO" => "Macau SAR China",
      "MK" => "Macedonia",
      "MG" => "Madagascar",
      "MW" => "Malawi",
      "MY" => "Malaysia",
      "MV" => "Maldives",
      "ML" => "Mali",
      "MT" => "Malta",
      "MH" => "Marshall Islands",
      "MQ" => "Martinique",
      "MR" => "Mauritania",
      "MU" => "Mauritius",
      "YT" => "Mayotte",
      "MX" => "Mexico",
      "FM" => "Micronesia",
      "MD" => "Moldova",
      "MC" => "Monaco",
      "MN" => "Mongolia",
      "ME" => "Montenegro",
      "MS" => "Montserrat",
      "MA" => "Morocco",
      "MZ" => "Mozambique",
      "MM" => "Myanmar (Burma)",
      "NA" => "Namibia",
      "NR" => "Nauru",
      "NP" => "Nepal",
      "NL" => "Netherlands",
      "NC" => "New Caledonia",
      "NZ" => "New Zealand",
      "NI" => "Nicaragua",
      "NE" => "Niger",
      "NG" => "Nigeria",
      "NU" => "Niue",
      "NF" => "Norfolk Island",
      "KP" => "North Korea",
      "MP" => "Northern Mariana Islands",
      "NO" => "Norway",
      "OM" => "Oman",
      "PK" => "Pakistan",
      "PW" => "Palau",
      "PS" => "Palestinian Territories",
      "PA" => "Panama",
      "PG" => "Papua New Guinea",
      "PY" => "Paraguay",
      "PE" => "Peru",
      "PH" => "Philippines",
      "PN" => "Pitcairn Islands",
      "PL" => "Poland",
      "PT" => "Portugal",
      "PR" => "Puerto Rico",
      "QA" => "Qatar",
      "RE" => "Réunion",
      "RO" => "Romania",
      "RU" => "Russia",
      "RW" => "Rwanda",
      "WS" => "Samoa",
      "SM" => "San Marino",
      "ST" => "São Tomé &amp; Príncipe",
      "SA" => "Saudi Arabia",
      "SN" => "Senegal",
      "RS" => "Serbia",
      "SC" => "Seychelles",
      "SL" => "Sierra Leone",
      "SG" => "Singapore",
      "SK" => "Slovakia",
      "SI" => "Slovenia",
      "SB" => "Solomon Islands",
      "SO" => "Somalia",
      "ZA" => "South Africa",
      "KR" => "South Korea",
      "SS" => "South Sudan",
      "ES" => "Spain",
      "LK" => "Sri Lanka",
      "BL" => "St. Barthélemy",
      "SH" => "St. Helena",
      "KN" => "St. Kitts &amp; Nevis",
      "LC" => "St. Lucia",
      "MF" => "St. Martin",
      "PM" => "St. Pierre &amp; Miquelon",
      "VC" => "St. Vincent &amp; Grenadines",
      "SD" => "Sudan",
      "SR" => "Suriname",
      "SZ" => "Swaziland",
      "SE" => "Sweden",
      "CH" => "Switzerland",
      "SY" => "Syria",
      "TW" => "Taiwan",
      "TJ" => "Tajikistan",
      "TZ" => "Tanzania",
      "TH" => "Thailand",
      "TL" => "Timor-Leste",
      "TG" => "Togo",
      "TK" => "Tokelau",
      "TO" => "Tonga",
      "TT" => "Trinidad &amp; Tobago",
      "TN" => "Tunisia",
      "TR" => "Turkey",
      "TM" => "Turkmenistan",
      "TC" => "Turks &amp; Caicos Islands",
      "TV" => "Tuvalu",
      "VI" => "U.S. Virgin Islands",
      "UG" => "Uganda",
      "UA" => "Ukraine",
      "AE" => "United Arab Emirates",
      "GB" => "United Kingdom",
      "US" => "United States",
      "UY" => "Uruguay",
      "UZ" => "Uzbekistan",
      "VU" => "Vanuatu",
      "VE" => "Venezuela",
      "VN" => "Vietnam",
      "WF" => "Wallis &amp; Futuna",
      "YE" => "Yemen",
      "ZM" => "Zambia",
      "ZW" => "Zimbabwe"}

    if code == "give_full_map"
      return country
    else
      return country[code]
    end
  end

end
