<template>
  <div>
    <v-card
      outlined
      tile
    >
      <validation-observer
        ref="observer"
        v-slot="{ invalid }"
      >
        <v-form>
          <v-container>
            <v-card-text>
              <v-row>
                <v-col cols="12" sm="12" md="12">
                  <TextInput
                    v-model="email"
                    name="メールアドレス"
                    label="メールアドレス"
                    type="email"
                    rules="required|email|max:50"
                    :dense="true"
                    prependInnerIcon="mdi-email"
                  ></TextInput>
                </v-col>
              </v-row>

              <v-row>
                <v-col cols="12" sm="12" md="12">
                  <TextInput
                    v-model="password"
                    name="パスワード"
                    label="パスワード"
                    type="password"
                    rules="required|max:50|min:6"
                    :dense="true"
                    prependInnerIcon="mdi-lock"
                  ></TextInput>
                </v-col>
              </v-row>
            </v-card-text>
            <v-card-actions>
              <v-btn
                color="primary"
                block
                @click="login({
                  email: email,
                  password: password
                })"
                :disabled="invalid"
              >
              ログイン
              </v-btn>
            </v-card-actions>
          </v-container>
        </v-form>
      </validation-observer>
    </v-card>
    <v-container>
      <v-row class="align-center mt-2">
        <v-col cols="12" sm="12" md="6" class="text-caption text-center">
          アカウントをお持ちでないですか？
        </v-col>
        <v-col cols="12" sm="12" md="3">
          <v-btn
            color="primary"
            block
            @click="$router.push('/register')"
          >登録</v-btn>
        </v-col>
        <v-col cols="12" sm="12" md="3">
          <v-btn
            block
            color="secondary"
          >ゲスト</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
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