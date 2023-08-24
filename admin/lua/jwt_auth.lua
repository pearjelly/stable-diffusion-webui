local jwt = require "resty.jwt"
local b64secret = "QE9CMGw9NSNMT0pkTFRkUmcmaGZqWWdUcUclSypLN1Y1"
local token = ngx.var.cookie_webui_token
if token == nil then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
local jwt_obj = jwt:verify(ngx.decode_base64(b64secret), token)
if not jwt_obj["verified"] then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
local exp = jwt_obj["payload"]["exp"]
if exp < ngx.time() then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
ngx.var.instance = jwt_obj["payload"]["instance"]