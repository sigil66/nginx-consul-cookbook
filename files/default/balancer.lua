-- Note: This really shouldn't be delivered via a chef cookbook
-- this is a basic example meant for learning purposes

local _M = {}

local json = require "cjson"
local http = require "resty.http"

local upstreams = {}
local state = {}
local refresh_interval = 30

-- private
local function refresh(premature)
  if premature then
    return
  end

  local hc = http:new()
  local res, err = hc:request_uri "http://127.0.0.1:8500/v1/catalog/services", {
    method = "GET"
  }

  if res == nil then
    ngx.log(ngx.ERR, "consul: FAILED to refresh upstreams")
  elseif res.body then
    local services = json.decode(res.body)

    for service, tags in pairs(services) do
      local sub, err = hc:request_uri("http://127.0.0.1:8500/v1/catalog/service/" .. service .. "?tag=service", {
        method = "GET"
      })

      if sub.body then
        _M.set(service, json.decode(sub.body))
      end
    end

    ngx.log(ngx.ERR, "consul: refreshed upstreams")
  end
  
  local ok, err = ngx.timer.at(refresh_interval, refresh)
  if not ok then
    ngx.log(ngx.ERR, "failed to create the timer: ", err)
  end
end

-- public

-- start consul refresh
function _M:start(interval)
  self.refresh_interval = interval

  local ok, err = ngx.timer.at(0, refresh)
  if not ok then
    ngx.log(ngx.ERR, "failed to create the timer: ", err)
  end
end

-- set upstreams
function _M.set(name, nodes)
  upstreams[name] = nodes
end

-- get service nodes
function _M.service(name)
  local nodes = {}
  for index, node in ipairs(upstreams[name]) do
    nodes[index] = {
      address = node["Address"],
      port = node["ServicePort"]
    }
  end

  return nodes
end

-- get next node saving state per service
function _M.next(service)
  if upstreams[service] == nil then
    return nil
  end

  if state[service] == nil or state[service] > #upstreams[service] then
    state[service] = 1
  end

  local node = upstreams[service][state[service]]
  state[service] = state[service] + 1

  return {
    address = node["Address"],
    port = node["ServicePort"]
  }
end

return _M
