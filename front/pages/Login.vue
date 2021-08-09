<template>
  <validation-observer
    ref="observer"
    v-slot="{ invalid }"
  >
    <v-form>
      <v-row>
        <v-col cols="12" sm="12" md="12">
          <TextInput
            v-model="email"
            name="メールアドレス"
            label="メールアドレス"
            rules="required"
          ></TextInput>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12" sm="12" md="12">
          <TextInput
            v-model="password"
            name="パスワード"
            label="パスワード"
            rules="required"
          ></TextInput>
        </v-col>
      </v-row>

      <v-btn
        color="primary"
        text
        @click="login({
          email: email,
          password: password
        })"
        :disabled="invalid"
      >
      送信
      </v-btn>
    </v-form>
  </validation-observer>
</template>



<script>
import TextInput from "../components/Form/BaseTextInput";
import { mapActions } from "vuex";

import { ValidationObserver } from 'vee-validate';

export default {
  layout: 'auth',
  components: {
    TextInput,
    ValidationObserver,
  },
  data() {
    return {
      email: '',
      password: '',
    };
  },
  methods: {
    ...mapActions('auth', ['login']),
  }
}
</script>