import { mount } from '@vue/test-utils'
import Logo from '@/components/Logo.vue'

describe('Logo', () => {
  test('is a Vue instance', () => {
    const wrapper = mount(Logo)
    expect(wrapper.vm).toBeTruthy()
  })
}),
describe('circle ci による slack への通知テスト', () => {
  test('test', () => {
    expect(true).toBe(false);
  })
})
