import { required, max, oneOf } from 'vee-validate/dist/rules';
import { minTime, afterNow } from './vee-validate-custom';
import { extend, setInteractionMode, localize} from 'vee-validate';
import ja from 'vee-validate/dist/locale/ja';

setInteractionMode('eager')

extend('required', required)
extend('max', max)
extend('oneOf', oneOf)
extend('minTime', minTime)
extend('afterNow', afterNow)
localize('ja', ja)