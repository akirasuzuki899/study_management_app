export default function({ $axios }) {
  
  $axios.onRequest(config => {
    config.headers.client = window.localStorage.getItem("client")
    config.headers["access-token"] = window.localStorage.getItem("access-token")
    config.headers.uid = window.localStorage.getItem("uid")
    config.headers["token-type"] = window.localStorage.getItem("token-type")
  })
  
  $axios.onResponse(response => {
    $axios.setHeader('Access-Control-Allow-Origin', '*')
  })
}