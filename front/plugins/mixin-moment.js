import moment from 'moment'

export default {
  computed: {
    now: () => moment().format('YYYY-MM-DD'),
    date: function() {
      return function(date){
        if (!date) return ''
        return moment(date).format('YYYY-MM-DD')
      }
    },
    time: function(){
      return function(time) {
        if (!time) return ''
        return moment(time).format('HH:mm')
      }
    },
    dateTime: function(){
      return function(start, end) {
        if (!start || !end) return ''
        
        const start_date = this.date(start)
        const end_date = this.date(end)

        if (moment(end_date).isAfter(start_date)){
          return `${start_date} ${this.time(start)} 〜 ${end_date} ${this.time(end)}`
        } else {
          return `${start_date} ${this.time(start)} 〜 ${this.time(end)}`
        }
      }
    },
  }
}