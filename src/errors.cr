require "kemal"

error 404 do
  "Page not found!"
end

error 403 do
  "Access Forbidden!"
end

error 500 do
  "Internal Server Error!"
end
