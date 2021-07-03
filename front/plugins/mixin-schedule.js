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
        this.drag = false
        this.dragEvent = event   //参照渡し
        this.dragTime = null
        this.originalEvent.start = this.dragEvent.start
        this.originalEvent.end = this.dragEvent.end
      }
    },
    startTime (tms) {
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

        if (this.time(newEnd) !== "00:00" && tms.hour !== -1) {
          this.dragUpdate(
            {
              id: this.dragEvent.id,
              start: this.dateTime(newStart),
              end: this.dateTime(newEnd),
            }
          )
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
      console.log("this.drag")
      console.log(this.drag)
      this.dragTime = null
      this.dragEvent = null
    },
    cancelDrag () {
      if (this.dragEvent && this.dragTime !== null){
        this.dragUpdate(
          {
            id: this.dragEvent.id,
            start: this.dateTime(this.originalEvent.start),
            end: this.dateTime(this.originalEvent.end),
          }
        )
      }
      this.dragTime = null
      this.dragEvent = null
      this.drag = false
    },

    roundTime (time, down = true) {   //  引数と戻り値はms
      const roundTo = 15 // minutes
      const roundDownTime = roundTo * 60 * 1000

      return down
        ? time - time % roundDownTime   // 切り捨て
        : time + (roundDownTime - (time % roundDownTime))  //切り上げ
    },
    toTime (tms) {   //時間をmsで返す
      return new Date(tms.year, tms.month - 1, tms.day, tms.hour, tms.minute).getTime()
    },
  }
}