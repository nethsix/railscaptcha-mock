class Api::MetricsController < Api::BaseController
  # https://api.ringcaptcha.com/metrics?api_key=28bb4b81d67abaad1bb2a43c5a80d30a2ee67baf&from=2016-10-30T03:00:00%2B00:00&to=2016-10-31T03:00:00%2B00:00
  # http://ringo-staging.herokuapp.com/metrics?api_key=28bb4b81d67abaad1bb2a43c5a80d30a2ee67baf&from=2016-10-30T03:00:00%2B00:00&to=2016-10-31T03:00:00%2B00:00
  # https://bitbucket.org/ringcaptcha/api/src/9a92206f589d093079b405d699024278398c2687/apps/front/modules/metrics/actions/actions.class.php?at=master&fileviewer=file-view-default
  def index
	  # Proxy this one to Rails:
	  # TODO: net.Request('app.ringcaptcha.com/v2/metrics', r.Params())
	  # os.Getenv("DATABASE_URL")
	  # r.Param("api_key")

	  # Requires: from, to, api_key
	  # Optional: apps (key1|key2|key3)

    # select s.id, s.site_key from 
    #   site s left join 
    #   guests g on g.owner_id = s.user_id inner join 
    #   user_profile up 
    # on up.user_id = g.guest_id or up.user_id = s.user_id where s.deleted_at IS NULL

    # Get the list of sites from this API Key
    api_key = params[:api_key]
    up = UserProfile.find_by_customer_key(api_key)
    site_ids = (up.user.sites + up.user.guest_sites).reject { |s| s.deleted_at }.pluck(:id)
    # Refine and limit to apps if they are specified
    site_ids = (site_ids & params[:apps].split("|").collect { |a| a.to_i }) if params[:apps]

    # Normalize times
    interval_from = Time.parse(params[:from])
    interval_to   = Time.parse(params[:to])
    if interval_to - interval_from > 25.hours 
      interval_delta = 1.day
    else
      interval_delta = 1.hour
    end
    interval_from = interval_from.beginning_of_day
    interval_to   = interval_to.end_of_day

=begin
    metrics = Metric.where(app_id: site_ids). # App IDs are Site IDs...
      where('timestamp >= ?', interval_from).where('timestamp < ?', interval_to).
      select( 'extract(epoch FROM timestamp) as timestamp, LOWER(country) as country,
                verified_numbers, unique_numbers, total_spend,
                total_transactions, latency, total_gateway_transactions,
                total_gateway_spend, success_gateway_transactions').
       order(:timestamp)
=end
    metrics = Metric.where(app_id: site_ids). # App IDs are Site IDs...
      where('timestamp >= ?', interval_from).where('timestamp < ?', interval_to)
    # .group_by_day.group(:country).sum(:total_transactions)
    verifications = metrics.group(:country).select('country, 
                                   SUM(total_transactions) as total_transactions_sum,
                                   SUM(total_spend) as total_spend_sum,
                                   SUM(unique_numbers) as unique_numbers_sum,
                                   SUM(verified_numbers) as verified_numbers_sum, 
                                   AVG(latency) as latency_avg').all

    result = { verification: 
      { country:
        verifications.inject({}) { |a,m|
          a[m.country] =
            { transactions: m.total_transactions_sum,
              spend: m.total_spend_sum,
              rate: ("%0.02f" % 100 * (m.verified_numbers_sum / m.unique_numbers_sum) rescue "0.0"),
              latency: "%0.02f" % m.latency_avg }; a } } }

    
=begin
    {"verification":
     {"country":
      {"jp":
       {"transactions":2,"spend":0.24,"rate":"0.00","latency":"25"}
    },
    "timestamp":
      {"1477796400":
       {"transactions":2,"spend":0.24,"rate":"0.00","latency":"25"},
      "1477879200":
       {"transactions":0,"spend":0,"rate":null,"latency":0}
    },
    "total":
      {"transactions":2,"spend":0.24,"rate":"0","latency":"25"}
    },
    "gateway":
     {"country":
      {"jp":
       {"rate":0,"spend":0,"transactions":0}
    },"timestamp":
      {"1477796400":
       {"rate":null,"spend":0,"transactions":0},"1477800000":
       {"rate":0,"spend":0,"transactions":0},"1477879200":
       {"rate":null,"spend":0,"transactions":0}
    },"total":
      {"rate":0,"spend":0,"transactions":0}}}
=end
=begin
  dates = []
  dates = 
        $daterange = new dateperiod($from, new dateinterval($interval), $to);

        foreach ($daterange as $date) {
            $dates[] = $date->getTimestamp();
        }

        $size = count($dates);

        $verificationDefault = array_fill(0, $size, array(
            'transactions' => 0,
            'spend' => 0,
            'rate' => null,
            'latency' => 0,
        ));

        $gatewayDefault = array_fill(0, $size, array(
            'rate' => null,
            'spend' => 0,
            'transactions' => 0,
        ));

        $reduced = array(
            'verification' => array(
                'country' => array(),
                'timestamp' => array(),
                'total' => $this->defaultVerification,
            ),
            'gateway' => array(
                'country' => array(),
                'timestamp' => array(),
                'total' => $this->defaultGateway,
            ),
        );

        foreach ($data as $item) {
            $timestamp = $item['timestamp'];
            $country   = $item['country'];

            if ($interval == Manager::INTERVAL_DAYS) {
                $timestamp -= $timestamp % 86400;
            }

            if (!isset($reduced['verification']['timestamp'][$timestamp])) {
                $reduced['verification']['timestamp'][$timestamp] = $this->defaultVerification;
                $reduced['gateway']['timestamp'][$timestamp] = $this->defaultGateway;
            }

            if (!isset($reduced['verification']['country'][$country])) {
                $reduced['verification']['country'][$country] = $this->defaultVerification;
                $reduced['gateway']['country'][$country] = $this->defaultGateway;
            }

            // verification
            $reduced['verification']['country'][$country]['transactions'] += $item['total_transactions'];
            $reduced['verification']['country'][$country]['spend'] += $item['total_spend'];
            $reduced['verification']['country'][$country]['rate']['unique_numbers'] += $item['unique_numbers'];
            $reduced['verification']['country'][$country]['rate']['verified_numbers'] += $item['verified_numbers'];
            $reduced['verification']['country'][$country]['latency'][] = $item['latency'];

            $reduced['verification']['timestamp'][$timestamp]['transactions'] += $item['total_transactions'];
            $reduced['verification']['timestamp'][$timestamp]['spend'] += $item['total_spend'];
            $reduced['verification']['timestamp'][$timestamp]['rate']['unique_numbers'] += $item['unique_numbers'];
            $reduced['verification']['timestamp'][$timestamp]['rate']['verified_numbers'] += $item['verified_numbers'];
            $reduced['verification']['timestamp'][$timestamp]['latency'][] = $item['latency'];

            $reduced['verification']['total']['transactions'] += $item['total_transactions'];
            $reduced['verification']['total']['spend'] += $item['total_spend'];
            $reduced['verification']['total']['rate']['unique_numbers'] += $item['unique_numbers'];
            $reduced['verification']['total']['rate']['verified_numbers'] += $item['verified_numbers'];
            $reduced['verification']['total']['latency'][] = $item['latency'];

            // gateway
            $reduced['gateway']['country'][$country]['transactions'] += $item['total_gateway_transactions'];
            $reduced['gateway']['country'][$country]['spend'] += $item['total_gateway_spend'];
            $reduced['gateway']['country'][$country]['rate']['delivered'] += $item['success_gateway_transactions'];

            $reduced['gateway']['timestamp'][$timestamp]['transactions'] += $item['total_gateway_transactions'];
            $reduced['gateway']['timestamp'][$timestamp]['spend'] += $item['total_gateway_spend'];
            $reduced['gateway']['timestamp'][$timestamp]['rate']['delivered'] += $item['success_gateway_transactions'];

            $reduced['gateway']['total']['transactions'] += $item['total_gateway_transactions'];
            $reduced['gateway']['total']['spend'] += $item['total_gateway_spend'];
            $reduced['gateway']['total']['rate']['delivered'] += $item['success_gateway_transactions'];
        }

        foreach ($reduced['verification']['country'] as $country => $item) {
            $reduced['verification']['country'][$country]['latency'] = $this->median($item['latency']);
            $values = $reduced['verification']['country'][$country]['rate'];
            $reduced['verification']['country'][$country]['rate'] = $values['unique_numbers'] > 0 ? number_format(($values['verified_numbers'] * 100) / $values['unique_numbers'], 2) : 0;
        }

        foreach ($reduced['verification']['timestamp'] as $timestamp => $item) {
            $reduced['verification']['timestamp'][$timestamp]['latency'] = $this->median($item['latency']);
            $values = $reduced['verification']['timestamp'][$timestamp]['rate'];
            $reduced['verification']['timestamp'][$timestamp]['rate'] = $values['unique_numbers'] > 0 ? number_format(($values['verified_numbers'] * 100) / $values['unique_numbers'], 2) : 0;
        }

        foreach ($reduced['gateway']['country'] as $country => $item) {
            $transactions = $reduced['gateway']['country'][$country]['transactions'];
            $delivered = $reduced['gateway']['country'][$country]['rate']['delivered'];
            $reduced['gateway']['country'][$country]['rate'] = $transactions > 0 ? number_format(($delivered * 100) / $transactions, 2) : 0;
        }

        foreach ($reduced['gateway']['timestamp'] as $timestamp => $item) {
            $transactions = $reduced['gateway']['timestamp'][$timestamp]['transactions'];
            $delivered = $reduced['gateway']['timestamp'][$timestamp]['rate']['delivered'];
            $reduced['gateway']['timestamp'][$timestamp]['rate'] = $transactions > 0 ? number_format(($delivered * 100) / $transactions, 2) : 0;
        }

        // agregar ceros a verification
        $i = $reduced['verification']['timestamp'];
        $j = array_combine($dates, $verificationDefault);
        $arr = $i + $j;
        ksort($arr);
        $reduced['verification']['timestamp'] = $arr;

        // agregar ceros a gateway
        $i = $reduced['gateway']['timestamp'];
        $j = array_combine($dates, $gatewayDefault);
        $arr = $i + $j;
        ksort($arr);
        $reduced['gateway']['timestamp'] = $arr;

        $reduced['verification']['total']['latency'] = $this->median($reduced['verification']['total']['latency']);

        $values = $reduced['verification']['total']['rate'];
        $reduced['verification']['total']['rate'] = $values['unique_numbers'] > 0 ? number_format(($values['verified_numbers'] * 100) / $values['unique_numbers']) : 0;

        $transactions = $reduced['gateway']['total']['transactions'];
        $delivered = $reduced['gateway']['total']['rate']['delivered'];
        $reduced['gateway']['total']['rate'] = $transactions > 0 ? number_format(($delivered * 100) / $transactions, 2) : 0;

        return $reduced;
=end

    render json: result
  end
end
