<template>
<div>
  <label for="email">メールアドレス:</label>
  <input id="email" type="text" v-model="email">
  <label for="password">パスワード:</label>
  <input id="password" type="password" v-model="password">
  <br><br>
  <button @click="login">送信</button>
  <hr>
  <p>{{name}}</p>
</div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      name: '',
    };
  },
  methods: {
    login() {
      this.$store.dispatch('login', {
        email: this.email,
        password: this.password
      })
    }
  }
}
</script>