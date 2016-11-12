# Contribute

We always welcome your contribution and pull request.

## Automated testing

There are [Serverspec](http://serverspec.org/) based testing.

The tests files are in the `spec/` directory.

Before running the tests, you'll need to install some dependencies.

```
$ bundle install --path=vendor/bundle
```

Then to run the tests, just execute following.

```
$ bundle exec rake spec
```
