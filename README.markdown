![](http://i.imgur.com/6PGUo4g.png)
# TFGM Unofficial Rubygem
This is a Rubygem which acts as a wrapper for the [Transport for Greater Manchester REST API](http://developer.tfgm.com). This provides the most accurate car parks, bus and metrolink information available to freely consume through the **opendata.tfgm.com** REST API.

We built this to use internally in our project, EventBrite, for the [Innovation Challenge in Manchester](http://futureeverything.org/summit/conference/workshops-fringe-events/innovation-challenge/) (which won Best Under 21). The TFGM REST API is **new and unstable** as of March 2013 so we would avoid using it in production.

## Getting Started
* **Sign up for an API Key** &mdash; It's easy to sign up at [developer.tfgm.com](http://developer.tfgm.com) and you'll need a developer & application key. An example of what both the keys should like are: `a1b23cd4-ef67-890g-h123-4567i8jk9lmn` and they must be 36 characters in length.

* **Install the gem**
```ruby
gem install tfgm
```
 
* **Include it in your Ruby** &mdash; Insert this at the top of your Ruby code where you'll using TFGM.
```ruby
require 'tfgm'
```

* **Create an instance of TFGM::API**
```ruby
instance = TFGM::API.new("Developer Key", "Application Key")
```

* **Make it do something** &mdash; if you're unsure of what it can do, scroll down to "Manual" on this page.
```ruby
instance.stops_on_route('X50')
```

* **Have fun.** &mdash; Everything is returned as a `Hash.new` in Ruby. Use `.inspect` to extract data you need.

-----------------

## TFGM::API Manual
There's very limited data available, but we've outlined what's currently available below. Parameters denoted with `*` are mandatory.

### Car Parks

* Find all car parks in Greater Manchester
```ruby
# Parameters:
# (int)  *page     = default: 0
# (int)  *per_page = default: 10
instance.carparks(0, 5)
```

* Find a car park by ID
```ruby
# Parameters:
# (int) *id
instance.carpark(21915)
```

### Routes

* View all bus routes running in Greater Manchester
```ruby
# Parameters:
# None
instance.routes
```

* View bus route by ID
```ruby
# Parameters
# (string) *bus_code
instance.route('X50')
```

* Verify bus route exists
```ruby
# Parameters:
# (string) *bus_code
if instance.is_route('X50') then
# Route exists, yay!
end
```

* Bus stops on bus route
```ruby
# Parameters
# (string) *bus_code
instance.stops_on_route('X50')
```

### Bus stops

* Find bus stops near a geolocation
```ruby
# Parameters:
# (double) *latitude
# (double) *longitude
instance.bus_stops_near(52.91391221, -3.39414441)
```

* Find bus stop by ATCO Code
```ruby
# Parameters:
# (string) *atco_code
instance.bus_stop('1800SB04781')
```

* Find routes running from bus stop
```ruby
# Parameters:
# (string) *atco_code
instance.buses_on_stop('1800SB04781')
```

### Metrolink times

* View all journey times
```ruby
# Parameters:
# None
instance.journey_times
```

* View journey times for a single route
```ruby
# Parameters:
# (string) *journey_id
instance.journey_times('A56-Dunham_proxy')
```

-----------------

## Contributing
We all know the REST API for TFGM is **really buggy**, but it's a great start. I'm glad that it's available and can foster innovation in the city, so if you're interested in developing it with me, just play about with it.

Let me know via [@bilawalhameed on Twitter](http://twitter.com/bilawalhameed/) if you're interested before sending a pull request.
