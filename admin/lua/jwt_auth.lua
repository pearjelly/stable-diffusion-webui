local jwt = require "resty.jwt"
local secret = "@OB0l=5#LOJdLTdRg&hfjYgTqG%K*K7V5"
local token = ngx.var.cookie_token
if token == nil then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
local jwt_obj = jwt:verify(secret, token)
if not jwt_obj["verified"] then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
if jwt_obj["payload"]["exp"] < ngx.time() then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
ngx.var.instance = jwt_obj["payload"]["instance"]