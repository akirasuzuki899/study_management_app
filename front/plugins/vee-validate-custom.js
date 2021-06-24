const minTime = {
  params: ["startTime", "min"],
  validate: ( endTime, { startTime, min }) => {
    const tmp_date = '2000/01/03'
    const start = new Date(`${tmp_date} ${startTime}`)
    const end = new Date(`${tmp_date} ${endTime}`)

    if ( !startTime ) return true;

    if ( start.getTime() > end.getTime()) {
      const totalTime = end.setDate(end.getDate() + 1) - start
      return ( totalTime >= min*60*1000 ? true : false )

    } else if ( start.getTime() < end.getTime()) {
      const totalTime = end - start
      return ( totalTime >= min*60*1000 ? true : false )

    } else {
      const time_is_0h = start.getTime() == new Date(`${tmp_date} 00:00`).getTime() 
      const time_is_24h = start.getTime() == new Date(`${tmp_date} 24:00`).getTime()
      return ( start.getTime() == end.getTime() && time_is_0h || time_is_24h ? false : true ) 
    }
  },
  message: "合計時間は15分以上にしてください"
};

const afterNow = {
  params: ["date"],
  validate: ( startTime, { date }) => {
    const now = new Date
    const start = new Date(`${date} ${startTime}`)
  
    if ( !date ) return true;

    return start - now >= 0
  },
  message: "現在時刻より後にしてください(仮)"
}


export { minTime, afterNow }