import { required, max, min, oneOf, email } from 'vee-validate/dist/rules';
import { minTime, url } from './vee-validate-custom';
import { extend, setInteractionMode, localize} from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja';

setInteractionMode('eager')

extend('required', required)
extend('max', max)
extend('min', min)
extend('oneOf', oneOf)
extend('email', email)
extend('minTime', minTime)
extend('url', url)
localize('ja', ja)