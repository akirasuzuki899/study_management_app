import moment from 'moment'

export default {
  computed: {
    now: () => moment().format('YYYY-MM-DD'),
    moment: function() {
      return function(val){
        return moment(val)
      }
    },
    date: function() {
      return function(date){
        if (!date) return ''
        return moment(date).format('YYYY-MM-DD')
      }
    },
    dateMmDd: function() {
      return function(date){
        if (!date) return ''
        return moment(date).format('MM月DD日')
      }
    },
    time: function(){
      return function(time) {
        if (!time) return ''
        return moment(time).format('HH:mm')
      }
    },
    dateTime: function(){
      return function(dateTime) {
        if (!dateTime) return ''
        return moment(dateTime).format('YYYY-MM-DD HH:mm')
      }
    },
    fromToDateTime: function(){
      return function(start, end) {
        if (!start || !end) return ''
        
        const start_date = this.date(start)
        const end_date = this.date(end)

        if (moment(end_date).isAfter(start_date)){
          return `${this.dateMmDd(start)} ${this.time(start)} 〜 ${this.dateMmDd(end)} ${this.time(end)}`
        } else {
          return `${this.dateMmDd(start)} ${this.time(start)} 〜 ${this.time(end)}`
        }
      }
    },
    timeToMs: function(){
      return function(time) {
        if (!time) return ''
        return Number(moment(time).format('x'))
      }
    }
  }
}