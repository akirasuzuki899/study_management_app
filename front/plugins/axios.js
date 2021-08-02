export default function ({ $axios, redirect }) {
  $axios.onResponse((response) => {
    $axios.setHeader('Access-Control-Allow-Origin', '*')
    console.log("response")
    console.log(response)
  })
}