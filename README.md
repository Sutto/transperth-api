# Transperth API

This sample app is an example application for [RocketPants](https://github.com/filtersquad/rocket_pants) and makes use
of ActiveRecord, RocketPants and API Smith for an API client.

## Getting Started

To get started, clone this repository and enter it. Next:

    cp config/database.yml.sample config/database.yml
    # Edit the database.yml.sample
    rake db:create db:setup
    rails s

And next, visit:

- `http://localhost:3000/1/train_stations` - A list of all stations
- `http://localhost:3000/1/bus_stops/12345` - The bus stop with stop number 12345.
- `http://localhost:3000/1/smart_rider/12345` - The smart rider with id 12345.

## Contributing

We encourage all community contributions. Keeping this in mind, please follow these general guidelines when contributing:

* Fork the project
* Create a topic branch for what you’re working on (git checkout -b awesome_feature)
* Commit away, push that up (git push your\_remote awesome\_feature)
* Create a new GitHub Issue with the commit, asking for review. Alternatively, send a pull request with details of what you added.
* Once it’s accepted, if you want access to the core repository feel free to ask! Otherwise, you can continue to hack away in your own fork.

Other than that, our guidelines very closely match the GemCutter guidelines [here](http://wiki.github.com/qrush/gemcutter/contribution-guidelines).

(Thanks to [GemCutter](http://wiki.github.com/qrush/gemcutter/) for the contribution guide)

## License

Transperth API is released under the MIT License (see the [license file](./LICENSE)) and is
copyright Darcy Laycock, 2012.

This client is in no way affiliated with / endorsed by Transperth and is intended for education purposes only. Please note
Transperth and it's associated terms are property of Transperth itself and there is no association between this
code, myself and Transperth.