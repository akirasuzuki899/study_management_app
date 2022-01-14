module AuthorizationSpecHelper
  def sign_in(user)
    post "api/v1/auth/sign_in/",
      params: { email: user[:email], password: user[:password] }, headers: { 'ACCEPT' => 'application/json' }

    response.headers.slice('client', 'access-token', 'uid')
  end
end