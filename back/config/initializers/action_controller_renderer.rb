ActionController::Renderer.const_set('DEFAULTS', {
  http_host: "localhost:3000",
  https: false,
  method: "get",
  script_name: "",
  input: ""
}.freeze
)