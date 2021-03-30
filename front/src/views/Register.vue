<template>
<div>
  <label for="name">名前:</label>
  <input id="name" type="text" v-model="name">
  <label for="email">メールアドレス:</label>
  <input id="email" type="text" v-model="email">
  <label for="password">パスワード:</label>
  <input id="password" type="password" v-model="password">
  <br><br>
  <button @click="register">送信</button>
</div>
</template>

<script>
export default {
  data() {
    return {
      email: '',
      password: '',
      name: ''
    };
  },
  methods: {
    register() {
      this.$store.dispatch('register', {
        name: this.name,
        email: this.email,
        password: this.password,
      })
    }
  }
}
</script>