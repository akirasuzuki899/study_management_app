<template>
  <validation-observer
    ref="observer"
    v-slot="{ invalid }"
  >
    <v-form>
      <v-row>
        <v-col cols="12" sm="12" md="12">
          <TextInput
            v-model="name"
            name="名前"
            label="名前"
            rules="required|max:50"
          ></TextInput>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12" sm="12" md="12">
          <TextInput
            v-model="email"
            name="メールアドレス"
            label="メールアドレス"
            rules="required|max:50"
          ></TextInput>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12" sm="12" md="12">
          <TextInput
            v-model="password"
            name="パスワード"
            label="パスワード"
            rules="required|max:50"
          ></TextInput>
        </v-col>
      </v-row>

      <v-btn
        color="primary"
        text
        @click="register"
        :disabled="invalid"
      >
      送信
      </v-btn>
    </v-form>
  </validation-observer>
</template>

<script>
import TextInput from "../components/Form/BaseTextInput";

import { ValidationObserver } from 'vee-validate';
export default {
  auth: false,

  components: {
    TextInput,
    ValidationObserver,
  },
  data() {
    return {
      email: '',
      password: '',
      name: ''
    };
  },
  methods: {
    register() {
      this.$axios
        .post(
          '/api/v1/auth',
          {
            name: this.name,
            email: this.email,
            password: this.password,
          }
        )
        .then((response) => {
          this.$auth.setUserToken(response.headers["access-token"])
          this.$router.push("/");
        })
        .catch(error => {
          console.log(error);
        });
    }
  }
}
</script>