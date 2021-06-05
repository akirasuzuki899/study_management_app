export default function(context) {
  console.log("autoLogin")
  context.store.dispatch('autoLogin')
};