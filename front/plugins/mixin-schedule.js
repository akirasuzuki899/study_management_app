export default {
  data: function () {
    return {
      drag: false,
      dragTime: null,
      dragEvent: null,
      dragStart: null,
      originalEvent: {
        start: null,
        end: null,
      }
    }
  },
  methods: {
    startDrag ({ event, timed }) {
      if (event && timed) {
        this.dragEvent = event   //参照渡し
        this.dragTime = null
        this.originalEvent.start = this.dragEvent.start
        this.originalEvent.end = this.dragEvent.end
      }
    },
    startTime (tms) {
      this.drag = false
      const mouse = this.toTime(tms)

      if (this.dragEvent && this.dragTime === null) {
        const start = this.timeToMs(this.dragEvent.start)
        this.dragTime = mouse - start
      }
    },
    mouseMove (tms) {
      const mouse = this.toTime(tms)
      this.drag = true

      if (this.dragEvent && this.dragTime !== null) {
        const start = this.timeToMs(this.dragEvent.start)
        const end = this.timeToMs(this.dragEvent.end)
        const duration = end - start   //イベントの終始をmsで保持
        const newStartTime = mouse - this.dragTime  //イベントのスタートとクリックした時間との差をmsで保持
        const newStart = this.roundTime(newStartTime)
        const newEnd = newStart + duration

        if (this.time(newEnd) !== "00:00" && tms.hour >= 0) {
          this.dragUpdate({
            dragEvent: this.dragEvent,
            data: {
              start: this.dateTime(newStart),
              end: this.dateTime(newEnd),
            }
          })
        }

      }
    },
    endDrag () {
      if (this.dragEvent && this.dragTime !== null){
        if (this.dragEvent.start !== this.originalEvent.start || this.dragEvent.end !== this.originalEvent.end ){
          this.update({
            authTokens: this.authTokens,
            selectedTask: this.dragEvent,
            formData: {
              start_date: this.date(this.dragEvent.start),
              start_time: this.time(this.dragEvent.start),
              end_time: this.time(this.dragEvent.end),
            }
          })
        }
      }
      this.dragTime = null
      this.dragEvent = null
    },
    cancelDrag () {
      if (this.dragEvent && this.dragTime !== null){
        this.dragUpdate({
          dragEvent: this.dragEvent,
          data: {
            start: this.dateTime(this.originalEvent.start),
            end: this.dateTime(this.originalEvent.end),
          }
        })
      }
      this.dragTime = null
      this.dragEvent = null
      this.drag = false
    },

    roundTime (time, roundTo = 15, down = true) {
      const roundDownTime = roundTo * 60 * 1000

      return down
        ? time - time % roundDownTime   // 切り捨て
        : time + (roundDownTime - (time % roundDownTime))  //切り上げ
    },
    toTime (tms) {   //時間をms(UNIX時間)で返す
      return new Date(tms.year, tms.month - 1, tms.day, tms.hour, tms.minute).getTime()
    },


    createTask(tms) {
      if(this.$refs.taskShow.isOpen === false && this.drag === false) {
        const unixTime = this.roundTime(this.toTime(tms), 60)
        const startTime = tms.hour < 0 ? "00:00" : this.moment(unixTime).format('HH:mm')
        const endTime = tms.hour < 0 ? "01:00" : this.moment(unixTime).add(1, 'h').format('HH:mm')

        this.selecrtedTime.startTime = startTime
        this.selecrtedTime.endTime = endTime
        this.selecrtedTime.date = tms.date
        
        this.$refs.form.open();
      }
    },
    showTask ({ nativeEvent, event }) {
      if (this.drag === false) {

        const open = () => {
          this.selectedTask = event
          this.selectedElement = nativeEvent.target
          requestAnimationFrame(() => requestAnimationFrame(() => this.$refs.taskShow.open()))
        }

        if (this.$refs.taskShow.isOpen) {
          this.$refs.taskShow.isOpen = false
          requestAnimationFrame(() => requestAnimationFrame(() => open()))
        } else {
          open()
        }

        nativeEvent.stopPropagation()
      }
    },
    intervalFormat(interval) {  //縦軸の時間フォーマットを hh:mm に変更
      return interval.time
    },
    getEventColor (event) {
      return event.color
    },
  },
}