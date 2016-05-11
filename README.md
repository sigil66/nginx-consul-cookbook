# Nginx Consul Cookbook

Sets up Nginx Consul Vagrant lab.

## Supported Platforms

- Ubuntu 16.04

## Attributes

None

## Usage

### nginx-consul::default

Include `nginx-consul` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[nginx-consul::default]"
  ]
}
```

## License and Authors

License:: Apache 2.0
Author:: Sigil66 Ops (<ops@sigil66.com>)
