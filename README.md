# Sadiq

Async job processing for crystal lang

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  sadiq:
    github: mathieulaporte/sadiq
```

## Usage

```crystal
require "sadiq"
class Archive < Sadiq::AsyncWorker
  register
  def perform(args)
    # your code...
  end
end
```

Sadiq is resque "compatible", so you can use ruby resque to enqueu jobs, or monitor with resque web.

###Example :
In your ruby code :
```ruby
require 'resque'
class Archive
  @queue = 'crystal'
end
```
You can enqueu jobs like
In your crystal code :
```crystal
require "sadiq"
class Archive < Sadiq::AsyncWorker
  register
  def perform(args)
    # your code...
  end
end
```

### After compilation
```shell
./your-project-name -c [concurrency] -n [namespace] -q [queue]
```
## Contributing

1. Fork it ( https://github.com/[your-github-name]/sadiq/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[mathieulaporte]](https://github.com/[mathieulaporte]) Mathieu Laporte - creator, maintainer
