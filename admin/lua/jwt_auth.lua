local jwt = require "resty.jwt"
local b64secret = "QE9CMGw9NSNMT0pkTFRkUmcmaGZqWWdUcUclSypLN1Y1"
local token = ngx.var.cookie_webui_token
print(token)
if token == nil then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
local secret = ngx.decode_base64(b64secret)
print(secret)
local jwt_obj = jwt:verify(secret, token)
local verified = jwt_obj["verified"]
print(verified)
if not verified then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
local exp = jwt_obj["payload"]["exp"]
print(exp)
if exp < ngx.time() then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
local instance = jwt_obj["payload"]["instance"]
print(instance)
ngx.var.instance = instance