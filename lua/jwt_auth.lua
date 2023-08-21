local jwt = require "resty.jwt"
local secret = "@OB0l=5#LOJdLTdRg&hfjYgTqG%K*K7V5"
local token = ngx.var.http_authorization
print("abc")
print(ngx.var.cookie_token)
if token == nil then
    ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
local jwt_obj = jwt:verify(secret, token)
if not jwt_obj["verified"] then
    ngx.exit(ngx.HTTP_FORBIDDEN)
end
ngx.req.set_header("X-User-Id", jwt_obj["payload"]["user_id"])