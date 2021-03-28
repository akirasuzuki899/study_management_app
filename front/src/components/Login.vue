<template>
  <div>
    <label for="email">email:</label>
    <input type="text" id="email">
    <label for="password">password:</label>
    <input type="text" id="password">
    <button @click="submit">送信</button>
    <br>
    <p v-bind="name">ユーザー名:{{name}}</p>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data: function(){
    return {
      name: ""
    }
  },
  methods: {
    submit: function(){
      axios.post (
        'http://localhost:3000/api/v1/auth/sign_in',
        {
          "email": "test1@test.com",
          "password": "password"
        }
      )
      .then(response => {
        console.log(response.data.data.name);
        this.name = response.data.data.name
      })
      .catch(error => {
        console.log(error);
      });
    }
  }
}
</script>