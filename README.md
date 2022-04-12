# Spree Mobility

[![Build Status](https://travis-ci.org/spree-contrib/spree_mobility.svg?branch=master)](https://travis-ci.org/spree-contrib/spree_mobility)
[![Code Climate](https://codeclimate.com/github/spree-contrib/spree_mobility/badges/gpa.svg)](https://codeclimate.com/github/spree-contrib/spree_mobility)

This is the globalization project extracted from `spree_i18n` for [Spree Commerce][1] version 3.1+.

For previous Spree versions you can just use [spree_i18n][2].

See the [official Internationalization documentation][2] for more details.

Happy translating!

---

## Installation

Add the following to your `Gemfile`:

```ruby
gem 'spree_i18n', '~> 5.0'
gem 'spree_mobility', github: 'spree-contrib/spree_mobility'
```

Run `bundle install`

You can use the generator to install migrations and append spree_mobility assets to
your app spree manifest file.

    rails g spree_mobility:install

This will insert these lines into your spree manifest files:

```
vendor/assets/javascripts/spree/backend/all.js
//= require spree/backend/spree_mobility
```

---

## Model Translations

This feature uses the [Mobility][3] gem to localize model data.
So far the following models are translatable:

    Product, Promotion, OptionType, Taxonomy, Taxon, Property, Store and ShippingMethod.

Start your server and you should see a TRANSLATIONS link or a flag icon on each
admin section that supports this feature.

*Every record needs to have a translation. If by any chance you remove `spree_mobility`
from your Gemfile, add some records and then add `spree_mobility` gem back you might get
errors like ``undefined method for nilClass`` because Mobility will try fetch
translations that do not exist.*

---

## Contributing

[See corresponding guidelines][7]

---

Copyright (c) 2010-2021 [Spree Commerce Inc.][1] and other [contributors][5]. released under the [New BSD License][6]

[1]: http://spreecommerce.org
[2]: http://guides.spreecommerce.org/developer/i18n.html
[3]: https://github.com/shioyama/mobility
[5]: https://github.com/spree-contrib/spree_mobility/graphs/contributors
[6]: https://github.com/spree-contrib/spree_mobility/blob/master/LICENSE.md
[7]: https://github.com/spree-contrib/spree_mobility/blob/master/CONTRIBUTING.md
[8]: https://github.com/spree-contrib/spree_i18n
