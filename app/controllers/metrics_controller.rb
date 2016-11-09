class MetricsController < ApplicationController
  before_action :authenticate_user!

  <<-DOC
  call to
  local/metrics?api_key=user_key&apps=app_key&from=from_date%2B00:00&to=to_date

  returns
  {
    "verification":{
      "country":[],
      "timestamp":{"1477458000":{"transactions":0,"spend":0,"rate":null,"latency":0}}
      ,"total":{"rate":0,"spend":0,"transactions":0}
    }
  }

  if country exists
  "country":{"in":{"transactions":1,"spend":0.018,"rate":"100.00","latency":"12"}}

  DOC

  def index
    @user = current_user
    from = params[:from]
    to = params[:to]
    api_key = params[:api_key]
    apps = params[:apps]

    if api_key.present?
      key_user = UserProfile.where(:customer_key => api_key).first
      if key_user.user_id == @user.id
        user_sites = Site.where(:user_id => key_user.user_id)

        timestamps = Array.new
        countries = Array.new
        total_transactions = 0
        total_spent = 0
        total_rate = 0
        total_latency = 0
        total_verified_numbers = 0

        total_verified_numbers_c = 0
        total_transactions_c = 0
        for item in user_sites

          #when many apps
          user_metrics = Metric.where(:app_id => item.id)
          for metrics in user_metrics
            rate = (metrics.verified_numbers / metrics.total_transactions) * 100
            unix_time = metrics.timestamp.to_time.to_i
            output = "\"#{unix_time}\":{\"transactions\":#{metrics.total_transactions}," +
            "\"spend\":#{metrics.total_spend},\"rate\":#{rate},\"latency\":#{metrics.latency||0}}"

            #sum value totals
            total_transactions = total_transactions +  metrics.total_transactions
            total_spent = total_spent + metrics.total_spend
            total_verified_numbers = total_verified_numbers + metrics.verified_numbers
            total_rate = (total_verified_numbers / total_transactions) * 100
            total_latency = total_latency + (metrics.latency||0)

            #sum values by country
            if countries.any? {|h| h[:country] == metrics.country}

              total_transactions_c = total_transactions_c +  metrics.total_transactions
              total_verified_numbers_c = total_verified_numbers_c + metrics.verified_numbers

              rate_c = ( total_verified_numbers_c / total_transactions_c) * 100
              index_c = countries.index {|h| h[:country] == metrics.country}
              countries[index_c][:transactions] = countries[index_c][:transactions] + (metrics.total_transactions||0)
              countries[index_c][:spend] = countries[index_c][:spend] + (metrics.total_spend||0)
              countries[index_c][:rate] = countries[index_c][:rate] + (rate_c||0)
              countries[index_c][:latency] = countries[index_c][:latency] + (metrics.latency||0)
            else
              rate_c = (metrics.verified_numbers / metrics.total_transactions) * 100
              c_out = {
                :country => metrics.country,
                :transactions => metrics.total_transactions||0,
                :spend => metrics.total_spend||0,
                :rate => rate_c||0,
                :latency => metrics.latency||0
              }
              countries.push(c_out)
            end

            timestamps.push(output)
          end
        end

        #turn country sums into json output
        if countries.length > 0

          country_output = Array.new
          for country in countries
            country_out = country[:country].downcase
            transactions = country[:transactions]
            spend = country[:spend]
            rate = country[:rate]
            latency = country[:latency]
            c_out = "\"#{country_out}\":{\"transactions\":#{transactions}," +
            "\"spend\":#{spend},\"rate\":#{rate},\"latency\":#{latency}}"
            country_output.push(c_out)
          end

          msg = "{" +
            "\"verification\"" + ":{" +
            "\"country\":{" + country_output.join(",") + "}," +
            "\"timestamp\":{" + timestamps.join(",") + "}" +
            ",\"total\":{\"rate\":#{total_rate},\"spend\":#{total_spent},\"transactions\":#{total_transactions},\"latency\":#{total_latency}}}}"
        else

          msg = "{" +
            "\"verification\"" + ":{" +
            "\"country\":" + "[]," +
            "\"timestamp\":{" + timestamps.join(",") + "}" +
            ",\"total\":{\"rate\":#{total_rate},\"spend\":#{total_spent},\"transactions\":#{total_transactions},\"latency\":#{total_latency}}}}"
        end


        render :json => msg
      else
        msg = {:message => "Sign in!"}
        render :json => msg
      end
    else
      msg = {:message => "Sign in!"}
      render :json => msg
    end


  end

end
