# Ruby client for the Afterbanks PSD2 API

[![CircleCI](https://circleci.com/gh/quipuapp/afterbanks-psd2-api-ruby.svg?style=shield)](https://circleci.com/gh/quipuapp/afterbanks-psd2-api-ruby)

This is a Ruby client for the Afterbanks' PSD2 API

Installation
---------

Install the gem (`gem install afterbanks-psd2-api-ruby`) or include it in your Gemfile and `bundle`.

Configuration
---------

Just set the service key by doing this:

```ruby
AfterbanksPSD2.servicekey = 'yourservicekey'
```

Or, if you use it in a Rails application, create an initializer with this content:

```ruby
require 'afterbanks_psd2'

AfterbanksPSD2.configure do |config|
  config.servicekey = 'yourservicekey'
end
```

You can set a `logger` as well.

Changelog
---------

* 0.1.1 Fix options parameters to ensure not null and check other parameters on Transaction.list
* 0.1.0 First full version, including resource wrapping (banks, user, accounts, transactions), error coverage and support for logging

TODO
----

* Full usage for each resource
* Proper explanation of the `AfterbanksPSD2:Error` and its subclasses

List of Error
------------

 *    `1` -> GenericError
 *   `50` -> IncorrectParametersError (When call API)
 * `C000` -> GenericConsentError
 * `C001` -> InvalidConsentError
 * `C002` -> ConsentWithUnfinalizedProcessError
 * `C003` -> ProductMismatchConsentError
 * `C004` -> ExpiredConsentError
 * `C005` -> MaximumNumberOfCallsReachedConsentError
 * `T000` -> GenericTransactionError
 * `T001` -> InvalidConsentForProductError



About Afterbanks
------------

* [Public site](https://www.afterbanks.com)
* [Documentation](https://app.swaggerhub.com/apis/Afterbanks/Afterbanks-PSD2-ES)
