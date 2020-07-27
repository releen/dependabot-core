## `dependabot-kiln`

Kiln support for [`dependabot-core`][core-repo].

### Running locally

1. Install Ruby dependencies
   ```
   $ bundle install
   ```

2. Run tests
   ```
   $ bundle exec rspec spec
   ```

**Note:** Integration tests will not pass without environment variables set or passed in.

[core-repo]: https://github.com/dependabot/dependabot-core

### Building and installing the gem

1. Build the gem
    ```
    $ gem build dependabot-kiln
    ```
2. Install the gem
    ```
    $ gem install dependabot-kiln-0.118.1.gem
    ```

