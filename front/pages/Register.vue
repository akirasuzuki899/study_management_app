<template>
  <validation-observer
    ref="observer"
    v-slot="{ invalid }"
  >
    <v-form>

      <v-row>
        <v-col cols="12" sm="12" md="12">
          <validation-provider
            v-slot="{ errors }"
            name="名前"
            rules="required"
          >
            <v-text-field
              label="名前"
              v-model="name"
              :error-messages="errors"
              required
            ></v-text-field>
          </validation-provider>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12" sm="12" md="12">
          <validation-provider
            v-slot="{ errors }"
            name="メールアドレス"
            rules="required"
          >
            <v-text-field
              label="メールアドレス"
              v-model="email"
              :error-messages="errors"
              required
            ></v-text-field>
          </validation-provider>
        </v-col>
      </v-row>

      <v-row>
        <v-col cols="12" sm="12" md="12">
          <validation-provider
            v-slot="{ errors }"
            name="パスワード"
            rules="required"
          >
            <v-text-field
              label="パスワード"
              v-model="password"
              :error-messages="errors"
              type="password"
              required
            ></v-text-field>
          </validation-provider>  
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
import { required, max, oneOf } from 'vee-validate/dist/rules';
import { minTime } from '../plugins/vee-validate';
import { extend, ValidationObserver, ValidationProvider, setInteractionMode, localize} from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja';

setInteractionMode('eager')

extend('required', required)
extend('max', max)
extend('oneOf', oneOf)
extend('minTime', minTime)
localize('ja', ja)

export default {
  components: {
    ValidationProvider,
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
      this.$store.dispatch('register', {
        name: this.name,
        email: this.email,
        password: this.password,
      })
    }
  }
}
</script>